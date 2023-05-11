from kafka import KafkaConsumer

print('Consumer started. Press Ctrl+C to stop.')

try:
    consumer = KafkaConsumer(bootstrap_servers=['kafka-1:9092','kafka-2:9092','kafka3:9092'], group_id='mygroup')
    consumer.subscribe(['demo4'])
    for message in consumer:
        print(message)
except Exception as ex:
    print(str(ex))
except KeyboardInterrupt:
    pass
finally:
    if consumer is not None:
        consumer.close()

print('... closed.')
