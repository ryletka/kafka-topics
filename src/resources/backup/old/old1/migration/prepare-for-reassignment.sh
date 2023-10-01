if [ "$#" -eq 0 ]
then
    echo "no arguments"
    exit 1
fi


echo "Start reassignment preparing"

/opt/kafka/current/bin/kafka-topics.sh --list --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:9092 >> topics.txt

echo created topics.txt

java -jar kafka-reassign-helper.jar generate topics.txt $1

fileCount=$(ls -dq generate*.json | wc -l)

echo "created $fileCount file for topics to move"

echo -e "\nCreating generated files\n"

mkdir -p generated
for ((i = 1; i < $fileCount+1; i++ ))
do
/opt/kafka/current/bin/kafka-reassign-partitions.sh --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:9092 --broker-list "4,5,6" --topics-to-move-json-file "generate$i.json" --generate >> "generated/generated$i.txt"
echo "generated/generated$i.txt" created
done

echo -e "\nCreating execute/rollback files"

java -jar kafka-reassign-helper.jar execute $fileCount

echo -e "\nexecute/rollback files created"

echo -e "\nPreparing finished successfully!"