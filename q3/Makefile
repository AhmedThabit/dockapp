mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
COPYFILES   := q3.sh
include ../Makefile.inc

CMD=bench.sh
ARGS=

RUNTERM=-it -a stdin -a stdout -a stderr --ipc=host --privileged --net=host --pid=host
OPTS=--skip-startup-files --no-kill-all-on-exit --quiet --skip-runit

check: $(TS)
	### [ -z "${DISPLAY}" ] && exit 1
	xhost + || exit 1
	docker ps -a
	ls -al /dev/pts/ptmx 
	: chmod a+rw /dev/pts/ptmx
	docker run --rm -e DISPLAY ${RUNTERM} --label is_top_app=1 -v /tmp/:/tmp/:rw $(IMG) ${OPTS} -- ${CMD} "${ARGS}" || true
	ls -al /dev/pts/ptmx 
	: chmod a+rw /dev/pts/ptmx
