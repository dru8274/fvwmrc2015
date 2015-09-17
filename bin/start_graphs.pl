#!/usr/bin/perl

##  System stats collected periodically with Sys::Statistics::Linux,
##  then graphed with gnuplot, and displayed with FvwmButtons.
##
##  ~/projects/gnuplot-graphs/test1.pl

use strict ;
use warnings ;

use IPC::Run qw( run ) ;
use Path::Tiny ;
use Sys::Statistics::Linux ;    ##  libsys-statistics-linux-perl
use Math::Round ;               ##  libmath-round-perl
use feature qw(say) ;

my $samples = 50 ;

my $gnuplot = undef ;
define_gnuplot() ;

my $lxs = Sys::Statistics::Linux->new(
    cpustats  => 1,
    diskstats => 1,
    pgswstats => 1,
    memstats  => 1,
    netstats  => 1,
    ) ;

path("/dev/shm/data.dat")->remove ;
my $datfile = path("/dev/shm/data.dat") ;

##  Counter var for num of loop iterations
my $cnt = 0 ;

##  Graphs are not updated every iteration. 
##  Only when $cnt is divisible by $delta
my $delta = 1 ;

for ( ; $cnt < $samples ; $cnt++ )  {
    $datfile->append("$cnt\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\n") ;
} ;

while ( 1 )  {
    sleep 2 ;

    while (-e "/tmp/stopgraphs") { sleep 5 } ;

    my $stat = $lxs->get ;

    ##  Sys::Statistics::Linux::CpuStats : Not the equation that I expected.
    ##    $user + $system + $iowait = 100 - $idle = $cputotal

    ##  cpu usage for just the first core
    my $iowait0 = $stat->{cpustats}->{cpu0}->{iowait} ;
    my $cputotal0 = $stat->{cpustats}->{cpu0}->{total} ;
    my $cpu0 = nearest(.1, ($cputotal0 - $iowait0)/2) ;

    ##  cpu usage for both cores
    my $iowait = nearest(.1, $stat->{cpustats}->{cpu}->{iowait}) ;
    my $cputotal = nearest(.1, ($stat->{cpustats}->{cpu}->{total} - $iowait)) ;
    my $cpusystem = nearest(.1, $stat->{cpustats}->{cpu}->{system}) ;

#    say "cpu0 : $cpu0,  cputotal : $cputotal,  iowait : $iowait" ;

    ##  disk info, normalized to 8MB/s
    my $rdbyt  =  ceiling($stat->{diskstats}->{sda}->{rdbyt}, 8388608) ;
    my $wrtbyt = -ceiling($stat->{diskstats}->{sda}->{wrtbyt}, 8388608) ;

    ##  memory + page fault info
    my $memtotal = nearest(1, $stat->{memstats}->{memtotal} ) ;
    my $foo = $stat->{memstats}->{cached} + $stat->{memstats}->{buffers} ;
    my $bar = 100*($stat->{memstats}->{memused}-$foo) / $memtotal ;
    my $memused_low = nearest(.1, $bar ) ;
    my $memused_hi = ceiling($stat->{memstats}->{memused}*100/$memtotal, 100) ;

    ## wlan wifi info,normalized to 2Mbtye/sec
    my $rxbyts =  ceiling($stat->{netstats}->{eth0}->{rxbyt}, 2097152) ;
    my $txbyts = -ceiling($stat->{netstats}->{eth0}->{txbyt}, 2097152) ;
    $rxbyts = 0 unless defined $rxbyts ;
    $txbyts = 0 unless defined $txbyts ;

    my $hddtemp = readpipe("sudo /usr/sbin/hddtemp -nF /dev/sda") ;
    chomp $hddtemp ;
    my $cputemp = readpipe("cat /sys/devices/virtual/thermal/thermal_zone0/temp") ;
    $cputemp = nearest(.1, $cputemp/1000) ;

    #say "hddtemp : $hddtemp,   cputemp : $cputemp" ;

    $datfile->append("$cnt\t$cpusystem\t$cpu0\t$cputotal\t$iowait\t" .
        "$memused_low\t$memused_hi\t0\t0\t$rdbyt\t" .
        "$wrtbyt\t$rxbyts\t$txbyts\t$hddtemp\t$cputemp\n" ) ;

    ##  Update png displays
    if ($cnt%$delta == 0)  {

        ##  Calc range for the plot
        $foo = $cnt - $samples + 1 ;
        $bar = $cnt + .5 ;
        my $prefix = "set xrange [$foo:$bar]" ;

        ##  Run gnuplot
        my @cmd = qw( gnuplot ) ;
        my $in = $prefix . $gnuplot ;
        my $out = my $err = "" ;
        run \@cmd, \$in, \$out, \$err ;

        system("FvwmCommand UpdateGraphs") ;
    }

    $cnt++ ;
}

##  Sets max threshold, then normalizes and returns as a percentage.
sub ceiling  {
    my ($num, $max) = @_ ;
    $num = 0 unless defined $num ;
    $num = $num > $max ? $max : $num ;
    return nearest(.1, $num*100/$max) ;
}

sub define_gnuplot  {

    $gnuplot = q{

##  VARIABLES

datfile = "/dev/shm/data.dat"

file1 = "/dev/shm/plot1.png"
file2 = "/dev/shm/plot2.png"
file3 = "/dev/shm/plot3.png"
file4 = "/dev/shm/plot4.png"
file5 = "/dev/shm/plot5.png"

##  png size for plots 1+2
xsize1 = "250"
ysize1 = "111" 
##  png size for plots 3+4
xsize2 = "250"
ysize2 = "111" 

##  the color for most text
color1 = "grey80"
##  color for the borders
color2 = "grey40"
##  colors for plots 1+2
color3 = "#3A4B57"
#
# blue
#color4 = "#5A7485"
#color4 = "#507085"
#    color4 = "#517891"
color4="#417291"

color5 = "#B2B236"

##  colors for plots 3+4

# yellow
#color6 = "#969456"
#color6 = "#B3AF47"
#    color6 = "#B3B05A"
color6 = "#B3AF48"



color7 = "#51748C"

# purple
#color8 = "#503E59"
#color8 = "#5E4D66"
#color8 = "#664D60"
color8 = "#805976"

##  these style stay mostly unchanged

unset key
unset xtics
unset y2tics
set style fill solid 1 noborder 
set style rectangle fs solid 1.0 border  lc rgb color1
set ytics  offset  1 nomirror out scale 1, 0 textcolor rgbcolor color1
##  set xrange  [xstart:xend]
##  set x2range [xstart:xend]

##  [1] CPU/IOWAIT  PLOT

set terminal png size xsize1, ysize1 font "Droid Sans Mono,9" transparent truecolor
set output file1

set multiplot

set lmargin at screen 0.13
set rmargin at screen 0.97
set tmargin at screen 0.9
set bmargin at screen 0.2

set yrange [0:100]
set ytics ("0" 0 0, " 100" 100 0 )
set border 3 lc rgb color2 lw 2

set label 1 "total" at screen .15, screen .1 front tc rgb color1
set object 1 rectangle front noclip at screen .34, screen .1 \
    size screen .05, screen .05 fc rgb color4

set label 2 "sys" at screen .44, screen .1 front tc rgb color1
set object 2 rectangle front noclip at screen .57, screen .1 \
    size screen .05, screen .05 fc rgb "#96040F"

set label 3 "iowait" at screen .68, screen .1 front tc rgb color1
set object 3 rectangle front noclip at screen .9, screen .1 \
    size screen .05, screen .05 fc rgb color5 

plot datfile     \
        using 2 with filledcurves x1  lc rgbcolor "#95252E",  \
     "" using 1:2:3 with filledcurves lc rgb color3,  \
     "" using 1:3:4 with filledcurves lc rgb color4,  \
     "" using 5 with lines lw 2 lc rgb color5 

unset multiplot

##  [2] MEM USED / MAJOR PAGE FAULTS / SWAP USED

set terminal png size xsize1, ysize1 font "Droid Sans Mono,9" transparent truecolor

set output file2

set multiplot

set lmargin at screen 0.13
set rmargin at screen 0.97
set tmargin at screen 0.9
set bmargin at screen 0.2

set yrange  [0:100]
set ytics ("0" 0 0, " 1G7" 100 0 )
##  set y2range [0:100]
##  set y2tics ( "150" 100 0 )
##  set y2tics offset screen -.14 nomirror in scale 1, 0 textcolor rgbcolor color1
##  set border 11 lc rgb color2 lw 2
set border 3  lc rgb color2 lw 2

set label 1 "used" at screen .2, screen .1 front tc rgb color1
set object 1 rectangle front noclip at screen .39, screen .1 \
    size screen .05, screen .05 fc rgb color3

unset label 2
unset object 2

set label 3 "used+cache" at screen .5, screen .1 front tc rgb color1
set object 3 rectangle front noclip at screen .86, screen .1 \
    size screen .05, screen .05 fc rgb color4 

plot datfile     \
        using 6 with filledcurves x1  lc rgb color3,  \
     "" using 1:6:7 with filledcurves lc rgb color4


#        using 6 with filledcurves x1  lc rgb color6,  \
#     "" using 8 axes x1y2 with lines lw 2 lc rgbcolor "#95252E"  \
#     "" using 9 axes x1y2 with lines lw 2 lc rgb color5 

unset multiplot

##  [3] DISK RD/WR PLOT : PART 1

set terminal png size xsize2, ysize2 font "Droid Sans Mono,9"  transparent truecolor

set output file3

set multiplot

set lmargin at screen 0.13
set rmargin at screen 0.97
set tmargin at screen 0.9
set bmargin at screen 0.55

unset y2tics
set yrange  [0:100]
set ytics ("0" 0 0, "   8M" 100 0 )
set border 3  lc rgb color2 lw 2

unset y2tics
unset label 1
unset object 1
unset label 2
unset object 2
unset label 3
unset object 3

plot datfile using 10 with filledcurves x1 linecolor rgb color6

##  [4] DISK RD/WR PLOT : PART 2

set tmargin at screen 0.55
set bmargin at screen 0.2

set yrange [-100:0]
set ytics ( "  -8M" -100 0 )
set border 2 lc rgb color2 lw 2

set label 1 "read/s" at screen .23, screen .1 front tc rgb color1
set object 1 rectangle front noclip at screen .45, screen .1 \
    size screen .05, screen .05 fc rgb color6

unset label 2
unset object 2

set label 3 "write/s" at screen .58, screen .1 front tc rgb color1
set object 3 rectangle front noclip at screen .84, screen .1 \
    size screen .05, screen .05 fc rgb color7 

plot datfile using 11 with filledcurves x2 linecolor rgb color7

unset multiplot

##  [5] NETWORK RX/TX PLOT : PART 1

set terminal png size xsize2, ysize2 font "Droid Sans Mono,9"  transparent truecolor

set output file4

set multiplot

set lmargin at screen 0.13
set rmargin at screen 0.97
set tmargin at screen 0.9
set bmargin at screen 0.55

set yrange [0:100]
set ytics ("0" 0 0, "   2M" 100 0 )
set border 3  lc rgb color2 lw 2

unset label 1
unset object 1
unset label 2
unset object 2
unset label 3
unset object 3

plot datfile using 12 with filledcurves x1 linecolor rgb color6

##  [6] NETWORK RX/TX PLOT : PART 2

set tmargin at screen 0.55
set bmargin at screen 0.2

set yrange [-100:0]
set ytics ( "  -2M" -100 0 )
set border 2 lc rgb color2 lw 2

set label 1 "rxbyt/s" at screen .23, screen .1 front tc rgb color1
set object 1 rectangle front noclip at screen .49, screen .1 \
    size screen .05, screen .05 fc rgb color6

unset label 2
unset object 2

set label 3 "txbyt/s" at screen .58, screen .1 front tc rgb color1
set object 3 rectangle front noclip at screen .84, screen .1 \
    size screen .05, screen .05 fc rgb color7

plot datfile using 13 with filledcurves x2 linecolor rgb color7

unset multiplot

##  [6] CELCIUS GRAPH

set terminal png size xsize1, ysize1 font "Droid Sans Mono,9" transparent truecolor
set output file5

set multiplot

set lmargin at screen 0.13
set rmargin at screen 0.97
set tmargin at screen 0.9
set bmargin at screen 0.2

set yrange [15:75]
set ytics ("  15" 15 0, "  45" 45 0, "  75" 75 0 )
set border 3 lc rgb color2 lw 2

set label 1 "cpu" at screen .32, screen .1 front tc rgb color1
set object 1 rectangle front noclip at screen .47, screen .1 \
    size screen .05, screen .05 fc rgb color6

unset label 2
unset object 2

set label 3 "hdd" at screen .6, screen .1 front tc rgb color1
set object 3 rectangle front noclip at screen .75, screen .1 \
    size screen .05, screen .05 fc rgbcolor "#95252E"

plot datfile     \
        using 14 with lines lw 2 lc rgbcolor "#95252E",  \
     "" using 15 with lines lw 2 lc rgb color5  

unset multiplot


    }
}



