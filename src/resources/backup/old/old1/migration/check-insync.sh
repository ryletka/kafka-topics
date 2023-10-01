input="check-topics.txt"
rm -f $input

/opt/kafka/current/bin/kafka-topics.sh --list --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:9092 >> check-topics.txt

checkPerIter=100
i=0
list=""
notInsync=0
while IFS= read -r line
do
 ((i=i+1))
 list+="${line}|"
 if [ $i -eq $checkPerIter ]
  then
   list=${list::${#list}-1}
   echo "checking $list"
   count=$(/opt/kafka/current/bin/kafka-topics.sh --describe --topic $list --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:9092 | egrep "Isr: [4-6/,]{3}$" -c)
   if [ "$count" -ne 0 ]
    then
     /opt/kafka/current/bin/kafka-topics.sh --describe --topic $list --bootstrap-server 78.111.86.23:9092,78.111.86.21:9092,78.111.84.25:9092,45.138.25.11:9092,78.111.85.11:9092,78.111.84.29:9092 | egrep "Isr: [4-6/,]{3}$"
   fi
   ((notInsync=notInsync+count))
   list=""
   i=0
 fi
done < "$input"

echo "not insync: $notInsync"