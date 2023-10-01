progress=-1

while [ $progress != 0 ]
do

    progress=$(/opt/kafka/current/bin/kafka-reassign-partitions.sh --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:9092 --reassignment-json-file rollback/rollback$1.json --verify | grep "in progress" -c)
    complete=$(/opt/kafka/current/bin/kafka-reassign-partitions.sh --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:9092 --reassignment-json-file rollback/rollback$1.json --verify | grep "is complete" -c)
    failed=$(/opt/kafka/current/bin/kafka-reassign-partitions.sh --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:90922 --reassignment-json-file rollback/rollback$1.json --verify | grep "failed" -c)

    echo "In progress:" $progress;
    echo "Is complete:" $complete;
    echo "Failed:" $failed;

    sleep 2s

done