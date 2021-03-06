# http://stackoverflow.com/questions/18136918/how-to-get-current-directory-of-your-makefile
# http://www.gnu.org/software/make/manual/make.html#toc-Quick-Reference-1

RM     ?= rm
ECHO   ?= echo
SHELL  ?= /bin/bash
GREP   ?= grep
SED    ?= sed
MAKE   ?= make
DOCKER ?= docker
TR     ?= tr

# Makefile.inc is expected to be on the top level!
top_dir       :=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
#top_dir_name :=$(notdir $(patsubst %/,%,$(mkp))) # $(CURDIR)
mkfile_dir    := $(dir $(mkfile_path))
current_dir   := $(notdir $(patsubst %/,%,$(mkfile_dir)))


#### Docker Hub-related refs:
U    ?= malex984
I    ?= dockapp
REPO ?= ${U}/${I}

APP  ?= $(shell $(ECHO) "${current_dir}" | $(SED) -e 's@[\-]@_@g' | $(TR) '[:upper:]' '[:lower:]')
IMG  ?= ${REPO}:${APP}
TAG  ?= imaginary.mfo.de:5000/${U}/${APP}

DF     :=${mkfile_dir}/Dockerfile

### Parsing parts of Dockerfile:
BASE   :=$(shell $(GREP) -m 1 -iE '^ *FROM' ${DF} | $(SED) -e 's@^ *FROM  *@@g' -e 's@[:/ ]@_@g')
BASETEG:=$(shell $(GREP) -m 1 -iE '^ *FROM' ${DF} | $(SED) -e 's@^ *FROM *@@g' -e 's@${REPO}:@@g' -e 's@[:/ ]@_@g')
COPYFILES2 :=$(shell $(GREP) -iE '^ *COPY ' ${DF} | $(SED) -e 's@^ *COPY  *@@g' -e 's@ /.*@@g' | xargs -r)

# Absolute path to necessary local files
ACOPYFILES :=$(patsubst %,${mkfile_dir}/%,${COPYFILES})
ACOPYFILES2:=$(patsubst %,${mkfile_dir}/%,${COPYFILES2})

TS := ${top_dir}/${U}_${I}_${APP}.timestamp
SS := ${top_dir}/${BASE}.timestamp


all: show debug build prune show

show:
	$(ECHO)
	$(DOCKER) images
	$(DOCKER) ps -a
	ls -al /dev/pts/ptmx 
	: chmod a+rw /dev/pts/ptmx

debug:
	$(ECHO)
	$(ECHO) "Top dir           : ${top_dir}"
	$(ECHO) "Dockerfile        : ${DF}"
	$(ECHO) "Target            : ${TS}"
	$(ECHO)
	$(ECHO) "Base              : ${BASETEG} -> ${BASE}"
	$(ECHO) "Req               : ${SS}"
	$(ECHO)
	$(ECHO) "Deps              : ${ACOPYFILES}"
	$(ECHO) "Auto Deps         : ${ACOPYFILES2}"


DOCKER_BUILD_OPTS=--pull=false --force-rm=true --rm=true
# --no-cache=true

# ${TS} ${SS} 
build: ${DF} ${ACOPYFILES} ${ACOPYFILES2}
	$(RM) -f ${TS}
	cd ${mkfile_dir} && $(DOCKER) -D build ${DOCKER_BUILD_OPTS} -t "${IMG}" -f "${DF}" "${mkfile_dir}"
	$(DOCKER) tag "${IMG}" "${TAG}"
	$(MAKE) -C ${mkfile_dir}/ ${TS}

${SS}:
	cd ${top_dir}/${BASETEG}/ && $(MAKE) -C ${top_dir}/${BASETEG}/

${top_dir}/phusion_baseimage_0.9.18.timestamp:
	$(DOCKER) pull 'phusion/baseimage:0.9.18'
	$(DOCKER) images | $(GREP) -E 'phusion[\/]baseimage *0[\.]9[\.]18 ' > $@

${top_dir}/docker_compose_1.6.2.timestamp:
	$(DOCKER) pull 'docker/compose:1.6.2'
	$(DOCKER) images | grep -E 'docker[\/]compose *1[\.]6[\.]2 ' > $@

${TS}:
	$(DOCKER) images | $(GREP) -E "^${U}/${I}  *${APP}  *" > $@
#	${TS}
# ${SS} 
rebuild: ${DF} ${ACOPYFILES} ${ACOPYFILES2} ${mkfile_dir}/Makefile $(abspath $(lastword $(MAKEFILE_LIST)))
	$(RM) -f ${TS}
	$(MAKE) -C ${mkfile_dir}/ ${TS}

test: $(TS) check

push: ${TS}
	$(DOCKER) push "${TAG}"

# ${SS}
pull:
	$(DOCKER) pull "${IMG}"
	$(DOCKER) tag "${IMG}" "${TAG}"
	$(MAKE) -C ${mkfile_dir}/ ${TS}
	
fix:
	$(MAKE) -C ${mkfile_dir}/ ${TS}


cleanup:
	(cd ${make_dir}; $(MAKE) -i -k -C ${make_dir} clean || true; cd - )
	$(DOCKER) rmi "${IMG}"
	$(RM) -f ${TS}

prune:
	$(DOCKER) images -f "dangling=true" -q | xargs -r $(DOCKER) rmi
	
#force_look:
#	true


.SILENT :
