#!/bin/bash

echo "stopping kafka"
sudo su - kafka /tmp/init4/scripts/kafka-stop.sh

echo "stopping zookeeper"
sudo su - kafka /tmp/init4/scripts/zkStop.sh

echo "remove directories"
rm -rf /opt/kafka
rm -rf /opt/zookeeper
rm -rf /opt/java
rm -rf /opt/jdk-11.0.2/
rm -rf /opt/scripts

echo "uninstall completed!"
