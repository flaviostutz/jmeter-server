FROM ubuntu:14.04
MAINTAINER Flávio Stutz, flaviostutz@gmail.com

#install Java JRE 8
ENV JAVA_DIR /usr/java
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y openjdk-8-jre-headless wget && \
  mkdir ${JAVA_DIR} && \
  ln -s /usr/lib/jvm/java-8-openjdk-amd64 ${JAVA_DIR}/default

#install JMeter 3.0
ENV JMETER_VERSION 3.0
ENV JMETER_DIR apache-jmeter-${JMETER_VERSION}
ENV JMETER_ARCHIVE ${JMETER_DIR}.tgz
ENV JMETER_URL https://archive.apache.org/dist/jmeter/binaries/${JMETER_ARCHIVE}
RUN wget -q ${JMETER_URL} && \
  tar -xzf ${JMETER_ARCHIVE} -C /var/lib && \
  mv /var/lib/${JMETER_DIR} /var/lib/jmeter && \
  rm -rf ${JMETER_ARCHIVE}

#install sshd
#RUN apt-get update
RUN apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo 'root:root' |chpasswd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

#install supervisor
RUN apt-get install -y supervisor && \
    mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN ln -sf /dev/stdout /jmeter-server.log
COPY user.properties /var/lib/jmeter/bin/user.properties

#cleanup
RUN rm -rf /var/lib/apt/lists/* ${JMETER_ARCHIVE}

EXPOSE 22 24000 25000

CMD ["/usr/bin/supervisord"]
