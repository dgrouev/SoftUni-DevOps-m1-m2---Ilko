#!/usr/bin/env python
import pika
from time import sleep
from random import randrange

print(' [*] Logs topics emitter started. Press Ctrl+C to stop.')

try:
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.exchange_declare(exchange='topic_logs', exchange_type='topic')

    while True:
        # determine resource type
        res = randrange(0,100)
        rtype = 'cpu'
        if res % 2 == 0:
            rtype = 'ram'
        # determine resource load
        res = randrange(0,100)
        ltype = 'info'
        if res > 50:
            ltype = 'warn'
        if res > 80:
            ltype = 'crit'
        msg = ltype + ': ' + rtype + ' load is ' + str(res)
        routing_key = rtype + '.' + ltype
        channel.basic_publish(exchange='topic_logs', routing_key=routing_key, body=msg)
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