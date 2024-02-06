#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "/etc/os-release" ] && source "/etc/os-release"

get_controls

$ESUDO chmod 666 /dev/tty0
$ESUDO chmod 666 /dev/tty1
printf "\033c" > /dev/tty0
printf "\033c" > /dev/tty1

GAMEDIR="/$directory/ports/mystikbelle"
exec > >(tee "$GAMEDIR/log.txt") 2>&1

LIBDIR="$GAMEDIR/lib32"
BINDIR="$GAMEDIR/box86"

# gl4es
export LIBGL_FB=4

# system

export LD_LIBRARY_PATH="$LIBDIR:/usr/lib32:/usr/local/lib/arm-linux-gnueabihf/"

# box86
export BOX86_ALLOWMISSINGLIBS=1
export BOX86_LD_LIBRARY_PATH="$LIBDIR"
export BOX86_LIBGL="$LIBDIR/libGL.so.1"
#export BOX86_PATH="$BINDIR"

if [ "$OS_NAME" == "JELOS" ]; then
  export SPA_PLUGIN_DIR="/usr/lib32/spa-0.2"
  export PIPEWIRE_MODULE_DIR="/usr/lib32/pipewire-0.3/"
fi

cd $GAMEDIR

$ESUDO rm -rf ~/.config/MystikBelle
$ESUDO ln -s /$GAMEDIR/conf/MystikBelle ~/.config/

$ESUDO chmod 666 /dev/uinput

$GPTOKEYB "box86" -c "$GAMEDIR/mystikbelle.gptk" &
#echo "Loading, please wait... (might take a while!)" > /dev/tty0
$GAMEDIR/box86/box86 $GAMEDIR/runner

$ESUDO kill -9 $(pidof gptokeyb)
unset LD_LIBRARY_PATH
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1
printf "\033c" > /dev/tty0
