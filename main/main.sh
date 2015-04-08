#! /bin/bash

SELFDIR=`dirname "$0"`
SELFDIR=`cd "$SELFDIR" && pwd`

U=malex984
I=dockapp

echo
echo "Current Host: `uname -a`"
echo "Current User: `id`"
#USER_UID=$(id -u)
#set
#env

echo

X="NODISPLAY=1"
XSOCK=/tmp/.X11-unix/

case "$OSTYPE" in
 linux*) # For Linux host with X11:

   if [[ -d /tmp/.X11-unix/ ]] && [[  "$DISPLAY" =~ ^:[0-9]+ ]]; then
     echo "Forwarding X11 via xauth..."
     XAUTH=/tmp/.docker.xauth

     if [ ! -f $XAUTH ]; then
        touch $XAUTH
        xauth nlist :0 | sed -e "s/^..../ffff/" | xauth -f $XAUTH nmerge -
     fi
     echo "We now enable anyone to connect to this X11..."
     xhost +
     X="DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH"
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
sudo docker images -a

echo "Current docker containers: "
sudo docker ps -a
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
 $SELFDIR/menu.sh \
     "Your choice please?" \
     "A_Test_Application_A B_Same_Test_App Alsa_Test GUI_Shell Bash_in_MainGlueApp X11_Shell X11Server X11Server_VB Iceweasel Q3 Skype Cups_Server Media_Players QUIT"
  APP="$?"
  case "$APP" in

    207)
      if [ ! -z "$DISPLAY" ]; then
        echo "There seems to be X11 running already..."
      else
        echo "Starting X11: Xorg... "
        F="$XSOCK/.new.orig.id"
        $SELFDIR/sv.sh x11 Xorg.sh Xorg "$F"
        sleep 2
        ID=`cat "$F"`
        sudo rm "$F"
        unset F
        export DISPLAY=":$ID"
        unset ID
        export X="DISPLAY=$DISPLAY -v $XSOCK:$XSOCK"
     fi
    ;;

    208)
      if [ ! -z "$DISPLAY" ]; then
        echo "There seems to be X11 running already..."
      else
        echo "Starting X11: Xorg with (?) vb guest additions... "
        F="$XSOCK/.new.vb.id"
        $SELFDIR/sv.sh x11vb Xorg.sh Xorg "$F"
        sleep 2
        ID=`cat "$F"`
        sudo rm "$F"
        unset F
        export DISPLAY=":$ID"
        unset ID
        export X="DISPLAY=$DISPLAY -v $XSOCK:$XSOCK"
      fi
    ;;

    212)
      echo "Starting cups... " && $SELFDIR/sv.sh cups /usr/local/bin/start_cups.sh
    ;;

    213)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting GUI shell... Please run cmus/vlc/mplaye/xine yourself... " && $SELFDIR/run.sh play "rxvt-unicode -e bash"
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    211)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting skype... " && $SELFDIR/run.sh skype skype.sh
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    210)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting Q3... " && $SELFDIR/run.sh q3 /usr/games/openarena
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    209)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting iceweasel/firefox?... " && $SELFDIR/run.sh iceweasel firefox
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    206)
      if [ ! -z "$DISPLAY" ]; then
        echo "starting X11-SHELL for testing... " && $SELFDIR/run.sh xeyes "rxvt-unicode -e bash"
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

   204)
      if [ ! -z "$DISPLAY" ]; then
        echo "Starting gui shell (gedit, g3dviewer? + X11-apps)... " && $SELFDIR/run.sh gui "rxvt-unicode -e bash"
      else
        echo "Please start X11 beforehand!"
      fi
    ;;

    201)
      echo "Starting AppA1... " && $SELFDIR/A.sh "AAAAAAAAAAAAAA!"
    ;;

    202)
      echo "Starting AppA2... " && $SELFDIR/A.sh "BBBBBBBBBBBBBB!"
    ;;

    203)
      echo "Starting Alsa sound test on plughw:0,0/1... " && $SELFDIR/run.sh alsa /usr/local/bin/soundtest.sh
    ;;

    205)
      echo "Starting BASH..." && /bin/bash
    ;;

    *)
      echo
      echo "Thank You!"
      echo
      echo "Quiting... please make sure to kill any services yourself... "
      echo "Leftover containers: "
      sudo docker ps -a
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
#      sudo docker run -it --name sound \
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
#docker pull "$U/$I:x11vb"
#docker pull "$U/$I:skype"
#docker pull "$U/$I:q3"
#docker pull "$U/$I:iceweasel"
#docker pull "$U/$I:cups-in-docker"
