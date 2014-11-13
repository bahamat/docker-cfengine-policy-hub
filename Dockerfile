# Version: 3.6.2-1
FROM debian:7
MAINTAINER Brian Bennett bahamat@digitalelf.net
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 5308
EXPOSE 22
RUN ["apt-get", "update"]
RUN ["apt-get", "dist-upgrade", "-y"]
RUN ["apt-get", "install", "-y", "apt-utils"]
RUN ["apt-get", "install", "-y", "curl", "procps", "perl-modules", "openssh-server", "vim-nox", "whois"]
RUN curl -s -L http://cfengine.com/pub/gpg.key | apt-key add -
RUN echo "deb http://cfengine.com/pub/apt/packages stable main" > /etc/apt/sources.list.d/cfengine-community.list
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "cfengine-community"]
RUN rm -f /etc/ssh/ssh_host*key*
RUN rm -f /var/cfengine/ppkeys/*
RUN ["sed", "-i", "/services_autorun/ s/!any/any/", "/var/cfengine/masterfiles/def.cf"]
ADD cfengine /opt/local/bin/
ADD docker_autorun_ssh.cf /var/cfengine/masterfiles/services/autorun/docker_autorun_ssh.cf
RUN usermod -p $(mkpasswd -m sha-256 toor) root
RUN #(nop) Change it after logging in
RUN #(nop) Root password is 'toor'
CMD /opt/local/bin/cfengine
