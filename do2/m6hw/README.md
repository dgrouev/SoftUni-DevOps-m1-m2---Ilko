Homework M6: Apache Kafka
Assignment
You are expected to execute the following:
1. Create a set of two machines
• First should be dedicated to Apache Kafka (a single node cluster)
• Create a topic with three partitions and no replication
• Adjust the demonstrated producer to send custom messages (use your imagination) to the topic
• Adjust the demonstrated consumer to subscribe for the topic
• Second should be dedicated to monitoring and include Prometheus and Grafana (either as
containers or regular processes)
• This time, instead of the demonstrated JMX exporter, use the Kafka Exporter
(https://github.com/danielqsj/kafka_exporter)
• Prepare at least one visualization to display any of the metrics exposed by the exporter
Even though we should try to automate repetitive tasks as much as possible, the emphasis here is to have a working
solution and not a fully automated one. Functionality over automation