#!/bin/bash

echo "stopping kafka"
sudo su - kafka /tmp/old1/scripts/kafka-stop.sh

echo "stopping zookeeper"
sudo su - kafka /tmp/old1/scripts/zkStop.sh

echo "remove directories"
rm -rf /opt/kafka
rm -rf /opt/zookeeper
rm -rf /opt/java
rm -rf /opt/jdk-11.0.2/
rm -rf /opt/scripts
rm -rf /opt/migration

echo "uninstall completed!"
