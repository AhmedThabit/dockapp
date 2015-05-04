#! /bin/bash

U=malex984
I=dockapp

IMG="$U/$I:menu"

#PP="$1"
#shift
#CH="$@"

ID=$(docker ps -a | grep "$IMG" | awk '{ print $1 }')
echo $N

if [ -z $ID ]; then 
  # options for running terminal apps via docker run:
  RUNTERM="-it -a stdin -a stdout -a stderr"
  OPTS="--skip-startup-files --no-kill-all-on-exit --quiet --skip-runit"

  #docker run --rm $RUNTERM --net=none "$U/$I:menu" $OPTS -- "/usr/local/bin/menu.sh" "$@"
  #exit $?

  #   --name menu \
  ID=$(docker create $RUNTERM --net=none "$IMG" $OPTS -- "/usr/local/bin/menu.sh" "$@")
  #docker ps -a
fi

echo "Container for menu: $ID. Starting it..."
docker start -ai $ID
RET=$?

#echo $RET

#docker ps -a

# -d 
#docker exec -it $ID "/usr/local/bin/menu.sh" "$@"
#RET=$?
#echo $RET
#docker ps -a

# exit $RET

docker stop -t 5 $ID > /dev/null 2>&1
docker rm -f $ID > /dev/null 2>&1 

exit $RET
# docker pause menu
# $OPTS -- /menu.sh

