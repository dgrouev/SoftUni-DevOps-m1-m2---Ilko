# Homework M7: Elastic Stack

## Server Setup
### 1. Elasticsearch
1. Install Elasticsearch using the following commands:
``` shell
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-x86_64.rpm

sudo rpm -Uvh elasticsearch-*.rpm
```

2. Remove the originial elasticsearch.yml and place configured one:
``` shell
sudo sudo rm /etc/elasticsearch/elasticsearch.yml -f

sudo cp /vagrant/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

sudo cp /vagrant/jvm.options /etc/elasticsearch/jvm.options.d/
```

3. Start the Elasticsearch service
``` shell
sudo systemctl daemon-reload

sudo systemctl enable elasticsearch

sudo systemctl start elasticsearch
```

### 2. Logstash
1. Install Logstash using the following commands:
``` shell
wget https://artifacts.elastic.co/downloads/logstash/logstash-8.6.2-x86_64.rpm

sudo rpm -Uvh logstash-*.rpm
```

2. Configure Logstash to receive data from beats:
``` shell
sudo cp /vagrant/beats.conf /etc/logstash/conf.d/beats.conf
```
 - beats.conf:
 ``` conf
 input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
 ```
 <i>NOTE: Replace localhost in the beats.conf with the ip of the elasticsearch host, in the case they are hosted on different machines!</i>

3. Start the Logstash service
``` shell
sudo systemctl daemon-reload

sudo systemctl enable logstash

sudo systemctl start logstash
```


## Creating the Metricbeat.yml
2. Make the neccessary adjusments to send data to our Logstash hosted on the Docker Machine

## REST API Index Patter Creation
1. Send POST request with curl
``` shell
curl -XPOST http://192.168.99.101:5601/api/index_patterns/index_pattern -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "index_pattern": {
    "name":"Metricbeat",
    "title":"metricbeat-8.6.2-*",
    "timeFieldName":"@timestamp"
  }
}'
```

## Ubuntu vagrant box with Metricbeat
1. Provision node with the image ubuntu/trusty64
2. wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.6.2-amd64.deb
3. sudo vi /etc/metricbeat/metricbeat.yml
4. Comment line #92 and #94
5. Uncomment lines #105 and 107, setting host 192.168.99.104 with port 5000
It should look like this:
``` yml
104 # ------------------------------ Logstash Output -------------------------------
105 output.logstash:
106   # The Logstash hosts
107   hosts: ["192.168.99.104:5000"]
108
109   # Optional SSL. By default is off.
110   # List of root certificates for HTTPS server verifications
111   #ssl.certificate_authorities: ["/etc/pki/root/ca.pem"]
112
113   # Certificate for SSL client authentication
114   #ssl.certificate: "/etc/pki/client/cert.pem"
115
116   # Client Certificate Key
117   #ssl.key: "/etc/pki/client/cert.key"
118
119 # ================================= Processors =================================
```

6. sudo metricbeat test config
    - It should say 'Config OK'
7. sudo metricbeat modules list
    - system module should be enable, if not run sudo metricbeat modules enable system
8. If this is the first Metricbeat in our Elastic Stack Execute this command:
``` shell 
sudo metricbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.99.104:9200"]'
```
10. sudo service metricbeat start
