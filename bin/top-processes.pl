#!/usr/bin/perl

##  Conky Treeop script -- working nicely, but no color yet.
##  Optimized for 31x16 urxvt with terminus-bold-16

##  /home/nostromo/temp-treetop/test3.pl

##  urxvt -T Processesx  -geometry 31x16 -fn terminus-bold-16  -e ./test1.pl &

use strict ;
use warnings ;

use feature qw(say) ;
use local::lib  ;
#use Data::Dump qw( dump ) ;

use Term::ExtendedColor qw( fg ) ;      
use Term::ExtendedColor::Xresources qw( set_xterm_color ) ;
use List::MoreUtils qw( uniq natatime );
use Math::Round qw ( nearest ) ;               

##  libmath-round-perl libterm-extendedcolor-perl liblist-moreutils-perl

##  Exactly define the colors used.
##  4-blue, 2-green, 7,8,9 - colors for 3 info lines. 10 for boxchars

my $colors = set_xterm_color({
    2   => '60897C',
    4   => '547A99',
    7   => '999992',
    8   => '85857E',
    9   => '666661',
    10  => '4C4C49',
});

print $_ for values %{ $colors } ;

##  Term geometry.
my $cols = 30 ;
my $rows = 17 ;

##  Tput escape char combos for term formatting .
my $tcel = "\x0d\x1b\x5b\x4b" ;             # \r$(tput el) 
my $tclear = "\x1b\x5b\x48\x1b\x5b\x4a" ;   # tput clear
my $tcivis = "\x1b\x5b\x3f\x32\x35\x6c" ;   # tput civis 
my $tup = "\x1b\x4d" ;

# no buffer caching
$| = 1 ;

##  An invisible cursor for the urxvt.
print $tcivis ;

##  Write conkyrc + start the conky process.
my $conkyrc = "/tmp/conkyrc-treetop" ;
write_conkyrc() ;
open(CONKY, "conky -c $conkyrc 2>/dev/null | ") || 
    die "CONKY failed. \n" ;

while (<CONKY>) {

    my $idx = 0 ;
    my @items = () ;

    ##  Store conky data into arrays.
    my @cpux = my @memx = my @iox = () ;
    my @arx = split(/-O-|\n/) ;
    my @cpu_data = @arx[0..8]  ;
    my @mem_data = @arx[9..17] ;
    my %ior = @arx[18..27] ;
    my %iow = @arx[28..37] ;

    ##  Parse cpu data into formatted strings (@items)
    my $num = 0 ;
    my $triplets = natatime 3, @cpu_data ;
    while (my ($name, $pid, $usage) = $triplets->()) {
        my $cpu = sprintf( '%.1f', nearest(.1, $usage) ) ;
        $items[$idx++] = new_item($num++, $name, $pid, $cpu) ;
    }

    ##  Parse memory data into formatted strings (@items)
    $num = 0 ;
    $triplets = natatime 3, @mem_data ;
    while (my ($name, $pid, $usage) = $triplets->()) {
        $items[$idx++] = new_item($num++, $name, $pid, unit_convert( $usage ) ) ;
    }

    ##  Re-sort in/out disk data.
    my %io_sum = () ;
    foreach my $key ( uniq keys(%ior), keys(%iow) )  {
        $io_sum{$key}  = $ior{$key} || 0 ;
        $io_sum{$key} += $iow{$key} || 0 ;
    }

    ##  The top processes sorted by total r/w IO are now listed in @io_top.
    my @io_top = sort { $io_sum{$a} <=> $io_sum{$b} } keys(%io_sum) ;

    ##  Parse in/out data into formatted strings (@items)
    for (my $num = 0; $num < 3 ; $num++)  {
        my $name = pop @io_top ;
        $items[$idx++] = new_item($num, $name, 
            unit_convert($ior{$name}), unit_convert($iow{$name})
        ) ;
    }

    ####  PRINT INFO TO STDOUT

    print $tup x ($rows - 1) ;
    say $tcel ;
    say $tcel.fg(4, "  CPU               ") . 
        fg(4, "PID  CPU% ") ;
    say "  $items[0]" ;
    say "  $items[1]" ;
    say "  $items[2]" ;
    say $tcel ;
    say $tcel.fg(4, "  MEMORY            ") . 
        fg(4, "PID   MEM ") ;
    say "  $items[3]" ;
    say "  $items[4]" ;
    say "  $items[5]" ;
    say $tcel ;
    say $tcel.fg(4, '  IN/OUT             ') .
        fg(4, 'RD    WR ') ;
    say "  $items[6]" ;
    say "  $items[7]" ;
    say "  $items[8]" ;
    print $tcel ;
}

sub unit_convert   {
    my $x = shift ;
    my $u = ( $x < 999 )    ? $x :
         ( $x < 999499 ) ? nearest(1, $x/1000) : nearest(1, $x/1000000) ;
    my $v = ( $x < 999 )    ? "B" : ( $x < 999499 ) ? "K" : "M" ;
    return $u.$v ;
}

sub new_item {

    my @colors = qw( 7 8 9 9 ) ;

    my ($num, $name, $item1, $item2) = @_ ;
    my $wdth = $cols-15 ;

    my $fmt = fg($colors[$num], "%-${wdth}s %5s %5s ") ;
    $name = substr($name, 0, $wdth ) ;
    return sprintf( $fmt, $name, $item1, $item2) ;
}

##  ${top name 4}-O-${top pid 4}-O-${top cpu 4}-O-\
##  ${top_mem name 4}-O-${top_mem pid 4}-O-${top_mem mem_res 4}-O-\
##  ${top_io name 1}|${top_io io_write 1}|${top_io name 2}|${top_mem io_write 2}|${top_io name 3}|${top_io io_write 3}
##  ${top_io name 1}-O-${top_io io_perc 1}-O-${top_io name 2}-O-${top_mem io_perc 2}-O-${top_io name 3}-O-${top_io io_perc 3}-O-

sub write_conkyrc  {

open TXT, ">", $conkyrc || die " open conkyrc failed " ;
print TXT <<'EOF';

background        no
out_to_console    yes
out_to_x          no
own_window_type   panel

cpu_avg_samples   1
update_interval   5
total_run_times   0

format_human_readable   no
no_buffers              yes
uppercase               no
use_spacer              none

short_units       yes
double_buffer     yes

top_cpu_separate false
top_name_width      20

TEXT
${top name 1}-O-${top pid 1}-O-${top cpu 1}-O-\
${top name 2}-O-${top pid 2}-O-${top cpu 2}-O-\
${top name 3}-O-${top pid 3}-O-${top cpu 3}-O-\
${top_mem name 1}-O-${top_mem pid 1}-O-${top_mem mem_res 1}-O-\
${top_mem name 2}-O-${top_mem pid 2}-O-${top_mem mem_res 2}-O-\
${top_mem name 3}-O-${top_mem pid 3}-O-${top_mem mem_res 3}-O-\
${top_io name 1}-O-${top_io io_read 1}-O-\
${top_io name 2}-O-${top_io io_read 2}-O-\
${top_io name 3}-O-${top_io io_read 3}-O-\
${top_io name 4}-O-${top_io io_read 4}-O-\
${top_io name 5}-O-${top_io io_read 5}-O-\
${top_io name 1}-O-${top_io io_write 1}-O-\
${top_io name 2}-O-${top_io io_write 2}-O-\
${top_io name 3}-O-${top_io io_write 3}-O-\
${top_io name 4}-O-${top_io io_write 4}-O-\
${top_io name 5}-O-${top_io io_write 5}-O-\
EOF
close TXT ;

}


