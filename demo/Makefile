mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
COPYFILES   := demo.sh
include ../Makefile.inc

CMD=demo.sh
ARGS=

# -it -a stdin 
RUNTERM=-a stdout -a stderr --ipc=host --privileged --net=host --pid=host \
        -v /etc/localtime:/etc/localtime:ro -v /tmp/:/tmp/:rw \
        -v /var/run/docker.sock:/var/run/docker.sock
	# -P

### TODO: switch to remote docker / networking!?

OPTS=--skip-startup-files --no-kill-all-on-exit --quiet --skip-runit

check: $(TS)
	test -n "${DISPLAY}"
	test -z "${DISPLAY}" || xhost +
	docker ps -a
	ls -al /dev/pts/ptmx 
	: chmod a+rw /dev/pts/ptmx
	docker run --rm -e MENU_TRY="gui" -e DISPLAY ${RUNTERM} --label is_top_app=0 $(IMG) ${OPTS} -- ${CMD} ${ARGS}
	ls -al /dev/pts/ptmx 
	: chmod a+rw /dev/pts/ptmx

