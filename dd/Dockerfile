FROM malex984/dockapp:base

MAINTAINER Oleksandr Motsak <malex984@googlemail.com>

RUN update.sh && \
    curl -sSL https://get.docker.com/gpg | apt-key add - && \
    curl -sSL https://get.docker.com/ | sh && \
    clean.sh

# DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
# --no-install-recommends lxc-docker && \

#ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
#RUN chmod +x /usr/local/bin/docker

#RUN curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose 
#RUN chmod +x /usr/local/bin/docker-compose

# RUN chmod +x /usr/local/bin/docker /usr/local/bin/docker-compose
# RUN ln -s $HOME/bin/docker-latest $HOME/bin/docker
## ENV DOCKER_CERT_PATH=

# nsenter does not work from inside a container :(
# ADD ./baseimage-docker-nsenter ./docker-bash /usr/local/bin/

ENV DOCKER_HOST unix:///var/run/docker.sock
ENV NO_PROXY /var/run/docker.sock

# RUN groupadd -f -g 998 docker
# RUN usermod -a -G docker ur
# USER ur
# ENV HOME /home/ur
# VOLUME $HOME
# WORKDIR $HOME

