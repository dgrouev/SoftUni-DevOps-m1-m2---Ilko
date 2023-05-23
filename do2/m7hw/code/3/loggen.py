#!/usr/bin/env python
import pika
from time import sleep
from random import randrange

print(' [*] Logs generator started. Press Ctrl+C to stop.')

try:
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.exchange_declare(exchange='logs', exchange_type='fanout')

    while True:
        cpu = randrange(0,100)
        ltype = 'info'
        if cpu > 50:
            ltype = 'warn'
        msg = ltype + ': CPU load is ' + str(cpu)
        channel.basic_publish(exchange='logs', routing_key='', body=msg)
        print(" [x] Sent %r" % msg)
        slp = randrange(5,20)
        print(' [x] Sleep for ' + str(slp) + ' second(s).')
        sleep(slp)
except Exception as ex:
    print(str(ex))
except KeyboardInterrupt:
    pass
finally:
    if connection is not None:
        connection.close()