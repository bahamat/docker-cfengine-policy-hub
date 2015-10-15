# Version: 3.7.1-1
FROM debian:7
MAINTAINER Brian Bennett bahamat@digitalelf.net
ENV DEBIAN_FRONTEND noninteractive
ENV CFE_VERSION 3.7.1
EXPOSE 5308
EXPOSE 22
RUN ["apt-get", "update"]
RUN ["apt-get", "dist-upgrade", "-y"]
RUN ["apt-get", "install", "-y", "apt-utils"]
RUN ["apt-get", "install", "-y", "curl", "procps", "perl-modules", "openssh-server", "vim-nox", "whois", "libterm-readline-gnu-perl", "liblwp-protocol-https-perl"]
RUN curl -s -L http://cfengine.com/pub/gpg.key | apt-key add -
RUN echo "deb http://cfengine.com/pub/apt/packages stable main" > /etc/apt/sources.list.d/cfengine-community.list
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "cfengine-community"]
RUN rm -f /etc/ssh/ssh_host*key*
RUN rm -f /var/cfengine/ppkeys/*
RUN #(nop) invalidate from here.......
ADD cfengine /opt/local/bin/
ADD docker_autorun_ssh.cf /var/cfengine/masterfiles/services/autorun/docker_autorun_ssh.cf
ADD docker_autorun_design_center.cf /var/cfengine/masterfiles/services/autorun/docker_autorun_design_center.cf
ADD docker_autorun_design_center.cf.json /var/cfengine/masterfiles/services/autorun/docker_autorun_design_center.cf.json
RUN usermod -p $(mkpasswd -m sha-256 toor) root
RUN #(nop) Change it after logging in
RUN #(nop) Root password is 'toor'
CMD /opt/local/bin/cfengine
