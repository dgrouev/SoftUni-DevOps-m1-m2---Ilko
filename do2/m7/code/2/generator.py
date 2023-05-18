#!/usr/bin/env python
import pika
from time import sleep
from random import randrange

print(' [*] Tasks generator started. Press Ctrl+C to stop.')

try:
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.queue_declare(queue='task_queue', durable=True)
    
    idx = 1
    
    while True:
        st = 'Work Task #' + str(idx)
        channel.basic_publish(exchange='',routing_key='task_queue',body=st,properties=pika.BasicProperties(delivery_mode=pika.spec.PERSISTENT_DELIVERY_MODE))
        print(" [x] Sent %r" % st)
        slp = randrange(5,20)
        print(' [x] Sleep for ' + str(slp) + ' second(s).')
        sleep(slp)
        idx = idx + 1
except Exception as ex:
    print(str(ex))
except KeyboardInterrupt:
    pass
finally:
    if connection is not None:
        connection.close()