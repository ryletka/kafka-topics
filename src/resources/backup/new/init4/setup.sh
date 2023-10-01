#!/bin/bash

tar -xf openjdk-11.0.2_linux-x64_bin.tar.gz --one-top-level=/opt
tar -xf kafka_2.13-3.2.0.tgz --one-top-level=/opt/kafka
tar -xf apache-zookeeper-3.9.0-bin.tar.gz --one-top-level=/opt/zookeeper
#mkdir -p kafka/config
cp -r kafka/config /opt/kafka/config
#mkdir -p kafka/kafka-data
cp -r kafka/kafka-data /opt/kafka/kafka-data
#mkdir -p /opt/zookeeper/zookeeper-data
cp -r zookeeper/zookeeper-data /opt/zookeeper

ln -sfn /opt/kafka/kafka_2.13-3.2.0 /opt/kafka/current
ln -sfn /opt/zookeeper/apache-zookeeper-3.9.0-bin /opt/zookeeper/current
ln -sfn /opt/jdk-11.0.2/ /opt/java

rm -rf /opt/zookeeper/current/conf
cp -r zookeeper/conf /opt/zookeeper/current
cp -r scripts /opt

chown -R kafka:kafka /opt
chmod -R 700 /opt

#env_var start ------------------------------->

kafkaProfile=/home/kafka/.bash_profile

homeVar="export JAVA_HOME=/opt/java"
javaHome=$(cat $kafkaProfile | grep "$homeVar")


if [ "$javaHome" != "$homeVar" ]; then
    echo -e "\n$homeVar\n" >> $kafkaProfile
fi


pathVar="export PATH=\$JAVA_HOME/bin:\$PATH"
path=$(cat $kafkaProfile | grep "$pathVar")

if [ "$path" != "$pathVar" ]; then
    echo -e "\n$pathVar\n" >> $kafkaProfile
fi

#env_var end --------------------------------->




#ulimit start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

limitsFile=/etc/security/limits.conf

soft="kafka soft nofile 262144"
limitSoft=$(cat $limitsFile | grep "$soft")

if [ "$limitSoft" != "$soft" ]; then
    echo -e "\n$soft\n" >> $limitsFile
fi


hard="kafka hard nofile 262144"
limitHard=$(cat $limitsFile | grep "$hard")

if [ "$limitHard" != "$hard" ]; then
    echo -e "\n$hard\n" >> $limitsFile
fi

#ulimit end >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>