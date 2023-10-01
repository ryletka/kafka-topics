#!/bin/bash

echo "stopping kafka"
sudo su - kafka /tmp/init5/scripts/kafka-stop.sh

echo "stopping zookeeper"
sudo su - kafka /tmp/init5/scripts/zkStop.sh

echo "remove directories"
rm -rf /opt/kafka/current
rm -rf /opt/kafka/kafka_2.13-3.2.0
rm -rf /opt/zookeeper/current
rm -rf /opt/zookeeper/apache-zookeeper-3.9.0-bin
rm -rf /opt/java
rm -rf /opt/jdk-11.0.2/

echo "uninstall completed!"
