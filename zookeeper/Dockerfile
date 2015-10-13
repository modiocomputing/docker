FROM centos:7

# Prerequisites
RUN yum update -y
RUN yum install java-1.7.0-openjdk-headless -y
RUN yum install tar -y
ENV JAVA_HOME /usr/lib/jvm/jre

# Download & extract Zookeeper
ADD http://mirrors.myaegean.gr/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz /opt/
WORKDIR /opt
RUN tar -xzf zookeeper-3.4.6.tar.gz && rm -f zookeeper-3.4.6.tar.gz
WORKDIR /

# Setup directories
RUN ln -sf /opt/zookeeper-3.4.6 /opt/zookeeper
RUN mkdir -p /var/lib/zookeeper/data && ln -sf /var/lib/zookeeper/data /opt/zookeeper/data
RUN mkdir -p /var/lib/zookeeper/logs && ln -sf /var/lib/zookeeper/logs /opt/zookeeper/logs
RUN mkdir -p /var/lib/zookeeper/conf 
ADD conf /var/lib/zookeeper/conf/
RUN rm -rf /opt/zookeeper/conf && ln -sf /var/lib/zookeeper/conf /opt/zookeeper/conf

# Create user/group and setup directory permissions
RUN /sbin/groupadd -g 1000 zookeeper && /sbin/useradd -M -d /opt/zookeeper -g zookeeper -s /sbin/nologin -u 1000 zookeeper
RUN chown -R zookeeper:zookeeper /opt/zookeeper-3.4.6 && chown -R zookeeper:zookeeper /var/lib/zookeeper

ADD start.sh /
RUN chmod u+x /start.sh
USER zookeeper
CMD ["/start.sh"]

EXPOSE 2888 3888 2181
