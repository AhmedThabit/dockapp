FROM phusion/baseimage:0.9.18

MAINTAINER Oleksandr Motsak <malex984@googlemail.com>

COPY update.sh install.sh upgrade.sh clean.sh /usr/local/bin/

# Update & Install & Clean up APT
# Not: please if possible add all the packages to the following single install command!
RUN upgrade.sh && update.sh && install.sh --no-install-recommends \
                 aptitude wget curl git cups-bsd && \
                 clean.sh

# dist-upgrade ?

### RUN groupadd -r ur && useradd -r -g ur ur
#RUN groupadd -f -g 1000 ur
#RUN adduser --disabled-login --uid 1000 --gid 1000 --gecos 'non-root-user' ur
#RUN usermod -a -G sudo ur
#RUN mkdir -p /etc/sudoers.d && echo "ur ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ur && chmod 0440 /etc/sudoers.d/ur
# USER ur
# ENV HOME=/home/ur
### VOLUME $HOME # ?
# WORKDIR $HOME

COPY setup_ogl.sh hb.sh hb_wrapper.sh config_cups.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/config_cups.sh

RUN locale-gen en_US.utf8 && locale-gen de_DE.utf8 && locale-gen ru_RU.utf8

ADD https://raw.githubusercontent.com/phusion/baseimage-docker/master/image/bin/my_init /sbin/my_init
RUN chmod +x /sbin/my_init

# Use baseimage-docker's init system.
# CMD ["/sbin/my_init"]
ENTRYPOINT ["/sbin/my_init"]


