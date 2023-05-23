#!/usr/bin/env python
import pika
from time import sleep
from random import randrange

print(' [*] Producer started. Press Ctrl+C to stop.')

try:
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))

    channel = connection.channel()

    channel.queue_declare(queue='hello')

    idx = 1

    while True:
        st = 'Hello World #' + str(idx)
        channel.basic_publish(exchange='', routing_key='hello', body=st)
        print(" [x] Sent '" + st + "'")
        slp = randrange(10,30)
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