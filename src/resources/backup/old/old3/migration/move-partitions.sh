if [ "$#" -eq 0 ]
then
    echo "no arguments"
    exit 1
fi
        

/opt/kafka/current/bin/kafka-reassign-partitions.sh --reassignment-json-file "execute/execute$1.json" --execute --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:9092