mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
COPYFILES   := 
include ../Makefile.inc

CMD=npm
ARGS=-l

RUNTERM=-it -a stdin -a stdout -a stderr --ipc=host --net=host --pid=host
OPTS=--skip-startup-files --no-kill-all-on-exit --quiet --skip-runit

check: $(TS)
	docker ps -a
	ls -al /dev/pts/ptmx 
	: chmod a+rw /dev/pts/ptmx
	docker run --rm ${RUNTERM} -v /tmp/:/tmp/:rw $(IMG) ${OPTS} -- ${CMD} ${ARGS} || true
	ls -al /dev/pts/ptmx
	: chmod a+rw /dev/pts/ptmx
