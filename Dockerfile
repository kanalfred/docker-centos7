##############################
# Alfred Centos 7 Base
#
# https://bitbucket.org/cwt/docker-centos7-ssh/src/9bbdf3fa4aca5d4c59eda4c28cfd231d951ffcc6/Dockerfile?fileviewer=file-view-default
# supervisord: https://serversforhackers.com/monitoring-processes-with-supervisord
# SSHD setup: https://github.com/tutumcloud/tutum-centos/blob/master/centos7/Dockerfile
# supervisord tutorial : https://serversforhackers.com/monitoring-processes-with-supervisord
# supervisord: https://hub.docker.com/r/jkuetemeier/docker-centos-supervisor-cron/~/dockerfile/
# supervisord: https://gist.github.com/Mulkave/10559775
# supervisord: https://github.com/million12/docker-centos-supervisor
# docker run -h centos7 --name centos7 -p 2201:22 -d kanalfred/centos7
##############################

FROM centos:7
MAINTAINER Alfred Kan <kanalfred@gmail.com>

# Add Files
ADD container-files / 

ENV DOCKERIZE_VERSION v0.2.0

# Add key for root user
#ADD container-files/key/authorized_keys2 /root/.ssh/authorized_keys

# root password
#RUN echo 'root:xxxxx' | chpasswd
RUN cat /root/root.txt | chpasswd

# Repo
RUN yum -y install epel-release && yum clean all

RUN \
    yum -y install \
        openssh openssh-server openssh-clients \
        sudo \
        passwd \
        cronie \
        wget \
        python-setuptools \
        sendmail \
        net-tools && \
        yum clean all && \

    # use easy install to get newer vesion of supervisor
    easy_install supervisor && \

    # sshd
    sshd-keygen && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && \

    #RUN chmod 600 /etc/supervisord.conf /etc/supervisord.d/*.ini

    # Dockerize 
    # Install dockerize - replace env var in config file
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Clean YUM caches to minimise Docker image size
RUN yum clean all && rm -rf /tmp/yum*

# Remove pass file
RUN rm -f /root/root.txt 

# EXPOSE
EXPOSE 22

# Run supervisord as demon with option -n 
CMD dockerize /config/run.sh
#CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

# Docker compose Env var 1.5 >
#image: "postgres:${POSTGRES_VERSION}"

# Run
#docker run -h centos6 -p 2200:22 -d --name centos6 -v /home/alfred/docker/data/centos6:/home/alfred/doc kanalfred/centos6
#docker run -h centos6 -p 192.168.3.129:22:22 -d --name centos6 -v /home/alfred/docker/data/centos6:/home/alfred/doc kanalfred/centos6

