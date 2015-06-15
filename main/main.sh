#! /bin/bash

ARGS=() #ARGS="$@"

if [ $# -gt 0 ]; then
  while [ "$1" != "" ]; do
    ARGS=("${ARGS[@]}" "$1") # ARGS+=($1)
    shift
  done
fi

SELFDIR=`dirname "$0"`
SELFDIR=`cd "$SELFDIR" && pwd`

U=malex984
I=dockapp
#
PREFIX="$U/$I"
echo
echo "Current Host: `uname -a`"
echo "Current User: `id`"
#USER_UID=$(id -u)
#set
#env

echo

XSOCK=/tmp/.X11-unix/
X="NODISPLAY=1"

case "$OSTYPE" in
 linux*) # For Linux host with X11:

   if [[ -d "$XSOCK" ]] && [[  "$DISPLAY" =~ ^:[0-9]+ ]]; then
     echo "Forwarding X11 via xauth..."
     XAUTH=/tmp/.docker.xauth

     if [ ! -f $XAUTH ]; then
        touch $XAUTH
        xauth nlist :0 | sed -e "s/^..../ffff/" | xauth -f $XAUTH nmerge -
     fi
     echo "We now enable anyone to connect to this X11..."
     xhost +
     xcompmgr &
     compton &
     X="DISPLAY -e XAUTHORITY=$XAUTH"
   else
# Detect a Virtual Box VM!?
     echo "Please start one of X11 servers before using any GUI apps... "
     X="NODISPLAY=1"
## TODO: start X11 server here??
   fi
 ;;

 darwin*) # our X11 host ip on Mac OS X via boot2docker:
  echo "TO BE TESTED!!!! Will probaby not work via Boot2Docker for now... Sorry! :("
  echo

  export DISPLAY="192.168.59.3:0"
  export X="DISPLAY"
  ## $(boot2docker ip) ## ???
  echo "Please make sure to start xsocat.sh from your local X11 server since xeys's X-client will use '-e $X'..."
  echo "X11 should 'Allow connections from network clients & Your firewall should not block incomming connections to X11'"
#  # X11 instead of XQuartz? Xpara?
  open -a XQuartz # --args xterm $PWD/xsocat.sh #?
 ;;
esac

echo "Will use the following X11 settings: "
echo "'$X'"
export X


echo "Current docker images: "
docker images

echo "Current docker containers: "
docker ps -a
echo


## options for /sbin/my_init:
#OPTS="--skip-startup-files --no-kill-all-on-exit --quiet --skip-runit"
## options for running terminal apps via docker run:
#RUNTERM="--rm -it  -a stdin -a stdout -a stderr"

echo
echo "This is the main glue loop running on ${HOSTNAME}:"
# uname -a


while :
do
 echo "Current X: '$X', DISPLAY: '$DISPLAY', XID: '$XID'"
 echo "Current commands '${ARGS[@]}' to be processed first..."

 if [ ! ${#ARGS[@]} -gt 0 ]; then
   $SELFDIR/menu.sh \
     "Your choice please?" 200 \
     "A_Test_Application_A LIBGL_CUSTOMIZATION Alsa_Test GUI_Shell Bash_in_MainGlueApp X11_Shell X11Server Xephyr Iceweasel Q3 Skype Cups_Server Media_Players Surfer Test QUIT"
   ARGS=("$?")
 fi

 APP="${ARGS[0]}" # get 1st  array element
 ARGS=("${ARGS[@]:1}") # remove it from array

 echo "Processing command '$APP'..."

 case "$APP" in
    207)
      if [ ! -z "$DISPLAY" ]; then
        echo "There seems to be X11 running already..."
      else
        echo "Starting X11: Xorg... "
        XID=$($SELFDIR/sv.sh 'dummy' startXephyr.sh)
        sleep 2
	docker logs $XID 2>&1 | grep DISPLAY
        export DISPLAY=$(docker logs $XID 2>&1 | grep DISPLAY_NUM | tail -n 1 | sed s@DISPLAY_NUM@@g)
        unset X
#        export X="DISPLAY=unix$DISPLAY"
        ### XAUTH?
     fi
    ;;

    208)
      if [ -z "$DISPLAY" ]; then
        echo "Please start X11 beforehand!"
      else
        echo "Starting X11: Xephyr using $DISPLAY... "
        XID=$($SELFDIR/sv.sh 'dummy' startXephyr.sh)
        sleep 2
	docker logs $XID 2>&1 | grep DISPLAY
        export DISPLAY=$(docker logs $XID 2>&1 | grep DISPLAY_NUM | tail -n 1 | sed s@DISPLAY_NUM@@g)
        unset X
#        export X="DISPLAY=unix$DISPLAY"
        ### XAUTH? 
      fi
    ;;

    212)
      echo "Starting cups... " && $SELFDIR/sv.sh "$PREFIX:cups" /usr/local/bin/start_cups.sh
    ;;

    215)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting GUI shell for test... Please build test yourself... " && $SELFDIR/run.sh 'test' launch.sh
	# "rxvt-unicode -fn xft:terminus:pixelsize=12 -e bash" ## xterm?
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    214)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting GUI shell for surfer... Please build surfer yourself... " 
	$SELFDIR/run.sh "$PREFIX:surfer" launch.sh /opt/SURFER/SURFER
#	$SELFDIR/run.sh "$PREFIX:appchoo" bash
        # "rxvt-unicode -fn xft:terminus:pixelsize=12 -e bash"
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    213)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting GUI shell... Please run cmus/vlc/mplaye/xine yourself... " && $SELFDIR/run.sh "$PREFIX:play" launch.sh
        # "rxvt-unicode -fn xft:terminus:pixelsize=12 -e bash"
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    211)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting skype... " && $SELFDIR/run.sh "$PREFIX:skype" skype.sh
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    210)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting Q3... " && $SELFDIR/run.sh "$PREFIX:q3" /usr/games/openarena
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    209)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting iceweasel/firefox?... " && $SELFDIR/run.sh "$PREFIX:iceweasel" firefox
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    206)
      if [ ! -z "$DISPLAY" ]; then
        echo "starting X11-SHELL for testing... " 
   	$SELFDIR/run.sh "$PREFIX:xeyes" xterm || $SELFDIR/run.sh "$PREFIX:xeyes" bash
        # "rxvt-unicode -fn xft:terminus:pixelsize=12 -e bash"
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

   204)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting gui shell (with X11-apps)... " && $SELFDIR/run.sh "$PREFIX:gui" launch.sh
        # "rxvt-unicode -fn xft:terminus:pixelsize=12 -e bash"
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    201)
      echo "Starting AppA1... " && $SELFDIR/A.sh "AAAAAAAAAAAAAA!"
    ;;

    202)
      echo "Generating /tmp/OGL.tgz with the use of malex984/dockapp:dummy... "
      $SELFDIR/generate_ogl.sh malex984/dockapp:dummy /tmp/OGL.tgz
      
    ;;

    203)
      echo "Starting Alsa sound test on plughw:0,0/1... " 
      $SELFDIR/run.sh "$PREFIX:alsa" soundtest.sh
    ;;

    205)
      echo "Starting BASH..." && bash
    ;;





    *)
      echo
      echo "Thank You!"
      echo
      echo "Quiting... please make sure to kill any services yourself... "
      
      if [ ! -z "$XID" ]; then
        echo "Killing X11: $XID"
        docker rm -vf $XID
      fi
      echo "Leftover containers: "
      docker ps -a
      
      exit 0
    ;;
  esac

  RET="$?"
  echo "Exit code was: $RET... Any now back to the choice menu:"
done




################ TODO: don't mount all of /dev/! Try to make use of the necessary devices only!

# -v /dev/shm:/dev/shm \
# -v /etc/machine-id:/etc/machine-id \
# -v /var/lib/dbus:/var/lib/dbus \
# -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
# -v /var/run/docker.sock:/var/run/docker.sock \
# -e DOCKER_HOST=unix:///var/run/docker.sock -e NO_PROXY=/var/run/docker.sock \
# -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
# -v /sys/fs/cgroup:/sys/fs/cgroup \
# -v /run/user/${USER_UID}/pulse:/run/user/${USER_UID}/pulse \
# -v /run/user/${USER_UID}/pulse:/run/pulse \
# -v /home/vagrant:/home/docker \
# -v /dev/dri:/dev/dri \
# --device=/dev/video0:/dev/video0 \
# -v /dev/snd:/dev/snd "
# -e PULSE_SERVER=/run/user/${USER_UID}/pulse/native \
#      docker run -it --name sound \
#        --privileged \
#       -e $SND \
#       --lxc-conf='lxc.cgroup.devices.allow=c 226:* rwm' \
#       --lxc-conf='lxc.cgroup.devices.allow=c 81:* rwm' \
#       --lxc-conf='lxc.cgroup.devices.allow=c 116:* rwm' \
#      "$U/$I:sound" /sbin/setuser ur /bin/bash

#echo "Pulling necessary images: "
#docker pull "$U/$I:base"
#docker pull "$U/$I:dd"
#docker pull "$U/$I:main"
#docker pull "$U/$I:menu"
#docker pull "$U/$I:appa"
#docker pull "$U/$I:alsa"
#docker pull "$U/$I:xeyes"
#docker pull "$U/$I:gui"
#docker pull "$U/$I:x11"
#docker pull "$U/$I:skype"
#docker pull "$U/$I:q3"
#docker pull "$U/$I:iceweasel"
#docker pull "$U/$I:cups"
