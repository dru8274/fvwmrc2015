#!/bin/bash

## [1] CREATE MENU ICONS

cd $FVWM_USERDIR/images/menus/main || exit
rm -r *

GEOM='20x20!' 
SRCDIR="$HOME/.icons/AwOken/clear/24x24/"
DESTDIR="$FVWM_USERDIR/images/menus/main/"

echo "* Creating Menu-Icons in $DESTDIR"

while read ICON NEWICON ;  do

    convert "$ICON" -quality 95% -adaptive-resize "$GEOM" "$NEWICON"

done <<EOF
$SRCDIR/apps/bmp.png                            $DESTDIR/mm_ncmpcpp.png
$SRCDIR/apps/gnome-keyring-manager.png          $DESTDIR/mm_figaro.png
$SRCDIR/apps/gnome-calculator.png               $DESTDIR/mm_calculator.png
$SRCDIR/apps/gcolor2.png                        $DESTDIR/mm_gcolor2.png
$SRCDIR/apps/gpick.png                          $DESTDIR/mm_gpick.png
$SRCDIR/aaoverlay/font-bitma.png                $DESTDIR/mm_gucharmap.png
$SRCDIR/apps/vim.png                            $DESTDIR/mm_gvim.png
$SRCDIR/apps/geany.png                          $DESTDIR/mm_geany.png
$SRCDIR/apps/terminal3.png                      $DESTDIR/mm_sakura.png
$SRCDIR/apps/thunar.png                         $DESTDIR/mm_thunar.png
$SRCDIR/apps/terminal3.png                      $DESTDIR/mm_urxvt.png
$SRCDIR/apps/terminal3.png                      $DESTDIR/mm_xterm.png
$SRCDIR/apps/terminal3.png                      $DESTDIR/mm_fvwmconsole.png
$SRCDIR/apps/gpick.png                          $DESTDIR/mm_colorname.png
$SRCDIR/apps/eog2.png                           $DESTDIR/mm_eog.png
$SRCDIR/apps/eog2.png                           $DESTDIR/mm_gpicview.png
$SRCDIR/categories/plugin-snow.png              $DESTDIR/mm_imagemagick.png
$SRCDIR/apps/mirage.png                         $DESTDIR/mm_mirage.png
$SRCDIR/apps/viewnior.png                       $DESTDIR/mm_viewnior.png
$SRCDIR/apps/thunderbird1.png                   $DESTDIR/mm_icedove.png
$SRCDIR/apps/evolution2.png                     $DESTDIR/mm_email.png
$SRCDIR/apps/firefox2.png                       $DESTDIR/mm_iceweasel.png
$SRCDIR/apps/tor.png                            $DESTDIR/mm_tor-browser.png
$SRCDIR/categories/applications-internet1.png   $DESTDIR/mm_browser.png
$SRCDIR/apps/transmission.png                   $DESTDIR/mm_transmission.png
$SRCDIR/apps/avidemux.png                       $DESTDIR/mm_avidemux.png
$SRCDIR/apps/brasero.png                        $DESTDIR/mm_brasero.png
$SRCDIR/devices/media-optical-cd2.png           $DESTDIR/mm_devede.png
$SRCDIR/apps/mplayer.png                        $DESTDIR/mm_mpv.png
$SRCDIR/apps/sonata.png                         $DESTDIR/mm_sonata.png
$SRCDIR/apps/vlc2.png                           $DESTDIR/mm_vlc.png
$SRCDIR/apps/winff.png                          $DESTDIR/mm_winff.png
$SRCDIR/apps/acroread2.png                      $DESTDIR/mm_acroread.png
$SRCDIR/apps/acroread2.png                      $DESTDIR/mm_atril.png
$SRCDIR/apps/acroread2.png                      $DESTDIR/mm_evince.png
$SRCDIR/apps/libreoffice3-writer1.png           $DESTDIR/mm_libreoffice.png
$SRCDIR/apps/freemind.png                       $DESTDIR/mm_fbreader.png
$SRCDIR/apps/gparted2.png                       $DESTDIR/mm_gparted.png
$SRCDIR/apps/unetbootin.png                     $DESTDIR/mm_unetbootin.png
$SRCDIR/apps/flash2.png                         $DESTDIR/mm_flash.png
$SRCDIR/actions/gtk-zoom-in.png                 $DESTDIR/mm_xzoom.png
$SRCDIR/apps/x.png                              $DESTDIR/mm_xkill.png
$SRCDIR/apps/alarm-timer.png                    $DESTDIR/mm_alarmtimer.png
$SRCDIR/apps/gdm-login-photo2.png               $DESTDIR/mm_screenshot.png
$SRCDIR/actions/select-rectangular.png          $DESTDIR/mm_select_area.png
$SRCDIR/apps/ktip.png                           $DESTDIR/mm_identify.png
$SRCDIR/actions/calibrate.png                   $DESTDIR/mm_screenruler.png
$SRCDIR/apps/gnome-session-halt2.png            $DESTDIR/mm_session_shutdown.png
$SRCDIR/apps/gnome-session-reboot2.png          $DESTDIR/mm_session_reboot.png
$SRCDIR/categories/preferences-desktop1.png     $DESTDIR/settings_menu.png
$SRCDIR/categories/applications-system.png      $DESTDIR/system_menu.png
$SRCDIR/categories/applications-engineering.png $DESTDIR/accessories_menu.png
$SRCDIR/categories/applications-internet1.png   $DESTDIR/network_menu.png
$SRCDIR/apps/darktable2.png                     $DESTDIR/graphics_menu.png
$SRCDIR/apps/totem2.png                         $DESTDIR/multimedia_menu.png
$SRCDIR/apps/gnome-session-halt2.png            $DESTDIR/exit_menu.png
$HOME/.icons/AwOkenDark/clear/24x24/mimetypes/wordprocessing1.png $DESTDIR/office_menu.png
EOF

## [2]  CREATE MINI ICONS

cd $FVWM_USERDIR/images/mini-icons || exit
for x in * ; do unlink "$x" ; done

SRCDIR="$HOME/.icons/AwOken/clear/24x24/"
DESTDIR="$FVWM_USERDIR/images/mini-icons/"

echo "* Creating Mini-Icons in $DESTDIR"

while read ICON MINIICON ;  do

    #convert "$ICON" -quality 95% -adaptive-resize "$GEOM" "$NEWICON"
    ln -s "$ICON" "$MINIICON"

done <<EOF
$SRCDIR/apps/bmp.png                            $DESTDIR/mi_ncmpcpp.png
$SRCDIR/apps/gnome-keyring-manager.png          $DESTDIR/mi_figaro.png
$SRCDIR/apps/gnome-calculator.png               $DESTDIR/mi_calculator.png
$SRCDIR/apps/gcolor2.png                        $DESTDIR/mi_gcolor2.png
$SRCDIR/apps/gpick.png                          $DESTDIR/mi_gpick.png
$SRCDIR/aaoverlay/font-bitma.png                $DESTDIR/mi_gucharmap.png
$SRCDIR/apps/vim.png                            $DESTDIR/mi_gvim.png
$SRCDIR/apps/geany.png                          $DESTDIR/mi_geany.png
$SRCDIR/apps/terminal3.png                      $DESTDIR/mi_sakura.png
$SRCDIR/apps/thunar.png                         $DESTDIR/mi_thunar.png
$SRCDIR/apps/terminal3.png                      $DESTDIR/mi_urxvt.png
$SRCDIR/apps/terminal3.png                      $DESTDIR/mi_xterm.png
$SRCDIR/apps/terminal3.png                      $DESTDIR/mi_fvwmconsole.png
$SRCDIR/apps/gpick.png                          $DESTDIR/mi_colorname.png
$SRCDIR/apps/eog2.png                           $DESTDIR/mi_eog.png
$SRCDIR/apps/eog2.png                           $DESTDIR/mi_gpicview.png
$SRCDIR/categories/plugin-snow.png              $DESTDIR/mi_imagemagick.png
$SRCDIR/apps/mirage.png                         $DESTDIR/mi_mirage.png
$SRCDIR/apps/viewnior.png                       $DESTDIR/mi_viewnior.png
$SRCDIR/apps/thunderbird1.png                   $DESTDIR/mi_icedove.png
$SRCDIR/apps/evolution2.png                     $DESTDIR/mi_email.png
$SRCDIR/apps/firefox2.png                       $DESTDIR/mi_iceweasel.png
$SRCDIR/apps/tor.png                            $DESTDIR/mi_tor-browser.png
$SRCDIR/categories/applications-internet1.png   $DESTDIR/mi_browser.png
$SRCDIR/apps/transmission.png                   $DESTDIR/mi_transmission.png
$SRCDIR/apps/avidemux.png                       $DESTDIR/mi_avidemux.png
$SRCDIR/apps/brasero.png                        $DESTDIR/mi_brasero.png
$SRCDIR/devices/media-optical-cd2.png           $DESTDIR/mi_devede.png
$SRCDIR/apps/mplayer.png                        $DESTDIR/mi_mpv.png
$SRCDIR/apps/sonata.png                         $DESTDIR/mi_sonata.png
$SRCDIR/apps/vlc2.png                           $DESTDIR/mi_vlc.png
$SRCDIR/apps/winff.png                          $DESTDIR/mi_winff.png
$SRCDIR/apps/acroread2.png                      $DESTDIR/mi_acroread.png
$SRCDIR/apps/acroread2.png                      $DESTDIR/mi_atril.png
$SRCDIR/apps/acroread2.png                      $DESTDIR/mi_evince.png
$SRCDIR/apps/libreoffice3-writer1.png           $DESTDIR/mi_libreoffice.png
$SRCDIR/apps/freemind.png                       $DESTDIR/mi_fbreader.png
$SRCDIR/apps/gparted2.png                       $DESTDIR/mi_gparted.png
$SRCDIR/apps/unetbootin.png                     $DESTDIR/mi_unetbootin.png
$SRCDIR/apps/flash2.png                         $DESTDIR/mi_flash.png
$SRCDIR/actions/gtk-zoom-in.png                 $DESTDIR/mi_xzoom.png
$SRCDIR/apps/x.png                              $DESTDIR/mi_xkill.png
$SRCDIR/apps/ktip.png                           $DESTDIR/mi_identify.png
$SRCDIR/actions/calibrate.png                   $DESTDIR/mi_screenruler.png
EOF

FvwmCommand UpdateImagePath
























