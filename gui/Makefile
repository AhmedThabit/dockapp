mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
COPYFILES   := launch.sh x_64x64.png qclosebutton
include ../Makefile.inc

CMD=launch.sh xterm -e bash 

RUNTERM=-it -a stdin -a stdout -a stderr --ipc=host --privileged --net=host --pid=host
OPTS=--skip-startup-files --no-kill-all-on-exit --quiet --skip-runit

check: $(TS)
	### [ -z "${DISPLAY}" ] && exit 1
	xhost + || exit 1
	docker ps -a
	docker run --rm -e DISPLAY ${RUNTERM} --label is_top_app=1 -v /tmp/:/tmp/:rw $(IMG) ${OPTS} -- ${CMD}
