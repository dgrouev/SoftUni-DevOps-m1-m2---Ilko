from kafka import KafkaProducer
from time import sleep
from random import randrange

tpk = ['homework']
idx = 1
print('Producer started. Press Ctrl+C to stop. Working on topic=' + str(tpk))

try:
	producer = KafkaProducer(bootstrap_servers=['kafka:9092'])
	while True:
		if str(idx)[-1] == "1":
			st = 'This is the ' + str(idx) + 'st message!'
		elif str(idx)[-1] == "2":
			st = 'This is the ' + str(idx) + 'nd message!'
		elif str(idx)[-1] == "3":
			st = 'This is the ' + str(idx) + 'rd message!'
		else:
			st = 'This is the ' + str(idx) + 'th message!'
		print('message: ' + st)
		for t in tpk:
			producer.send(t, bytes(st, encoding='utf-8'))
		producer.flush()
		slp = randrange(1,10)
		print('Sleep for ' + str(slp) + ' second(s).')
		sleep(slp)
		idx = idx + 1
except Exception as ex:
	print(str(ex))
except KeyboardInterrupt:
	pass
finally:
	if producer is not None:
		producer.close()

print('... closed.')
