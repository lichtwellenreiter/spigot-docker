FROM debian
LABEL maintainer="Florian Thiévent <hi@thievent.org>"

#RUN apt-get update
RUN apt-get install -y openjdk-17-jdk ca-certificates-java
RUN apt-get install -y ant
    
# Fix certificate issues
RUN update-ca-certificates -f

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/jdk-17/
RUN export JAVA_HOME


ENV GOSU_VERSION 1.14
RUN set -eux
RUN apt-get update
RUN apt-get install -y gosu
RUN rm -rf /var/lib/apt/lists/*
# verify that the binary works
RUN gosu nobody true

# grab gosu for easy step-down from root
# RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#    && apt-get update && apt-get install -y curl rsync tmux && rm -rf /var/lib/apt/lists/* \
#    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
#    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
#    && gpg --verify /usr/local/bin/gosu.asc \
#    && rm /usr/local/bin/gosu.asc \
#    && chmod +x /usr/local/bin/gosu

RUN groupadd -g 1000 minecraft
RUN useradd -g minecraft -u 1000 -r -M minecraft
RUN touch /run/first_time
RUN mkdir -p /opt/minecraft /var/lib/minecraft /usr/src/minecraft
RUN echo "set -g status off" > /root/.tmux.conf

COPY spigot /usr/local/bin/
ONBUILD COPY . /usr/src/minecraft

EXPOSE 25565

VOLUME ["/opt/minecraft", "/var/lib/minecraft"]

ENTRYPOINT ["/usr/local/bin/spigot"]
CMD ["run"]
