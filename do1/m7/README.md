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
### 3. Kibana
1. Install Kibana using the following commands:
``` shell
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.6.2-x86_64.rpm

sudo rpm -Uvh kibana-*.rpm
```

2. Remove the originial kibana.yml and place configured one:
``` shell
sudo sudo rm /etc/kibana/kibana.yml -f

sudo cp /vagrant/kibana.yml /etc/kibana/kibana.yml
```

3. Start the Kibana service
``` shell
sudo systemctl daemon-reload

sudo systemctl enable kibana

sudo systemctl start kibana
```


### Open firewall ports and reload
``` shell
firewall-cmd --add-port 5044/tcp --permanent
firewall-cmd --add-port 5601/tcp --permanent
firewall-cmd --add-port 9200/tcp --permanent
firewall-cmd --reload
```

## Creating the elasticsearch.yml:
* Refactir the following lines, where #number is the number of the line
1. #17 cluster.name: mycluster
2. #23 node.name: server
3. #56 network.host: ["localhost", "192.168.99.101"]
4. #61 http.port: 9200
5. #98 xpack.security.enabled: false
6. #74* cluster.initial_master_nodes: ["server"]
  - Careful with line #74 as it might be auto-added at #115, which will cause error if it's declared twice

## Creating the kibana.yml:
* Refactir the following lines, where #number is the number of the line
1. #6 server.port: 5601
2. #11 server.host: "192.168.99.101"
3. #32 server.name: "server"
4. #43 elasticsearch.hosts: ["http://192.168.99.101:9200"]

## Creating the metricbeat.yml
1. Comment lines #92 and #94 and uncomment lines #105 and #107 to look like this:
``` shell
output.logstash:
  # The Logstash hosts
  hosts: ["192.168.99.101:5044"]
```

## Creating the jvm.options
<i>NOTE: We should limit the heap size to 50% of the total virtual memory on the machine we host elasticsearch. This is done by editing the /etc/elasticsearch/jvm.options or placing a new jvm.options in /etc/elasticsearch/jvm.options.d/ directory that looks like this:</i>
``` options
-Xms2g
-Xmx2g
```

## REST API Index Pattern Creation
1. Send POST request with curl the old way
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
2. As of version 8.0.* the proper way create Index Pattern via REST API is as follows:
``` shell
curl -X POST http://192.168.99.101:5601/api/data_views/data_view -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "data_view": {
    "name":"Metricbeat",
    "title":"metricbeat-8.6.2-*",
    "timeFieldName":"@timestamp"
  }
}'
```

## Vagrant box with Metricbeat
1. Provision node with the image
  - CentOS: shekeriev/centos-stream-9
  - Ubuntu:
2. Download and install Metricbeat:
  - CentOS
``` shell
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.6.2-x86_64.rpm

sudo rpm -Uvh metricbeat-8.6.2-x86_64.rpm
```
  - Ubuntu
``` shell
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.6.2-amd64.deb

sudo dpkg -i metricbeat-8.6.2-amd64.deb
```
4. Open the metricbeat.ymw with <strong>sudo vi /etc/metricbeat/metricbeat.yml</strong>
5. Comment line #92 and #94
6. Uncomment lines #105 and 107, setting host 192.168.99.101 with port 5044
It should look like this:
``` yml
104 # ------------------------------ Logstash Output -------------------------------
105 output.logstash:
106   # The Logstash hosts
107   hosts: ["192.168.99.101:5044"]
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
7. sudo metricbeat test config
    - It should say 'Config OK'
8. sudo metricbeat modules list
    - system module should be enable, if not run sudo metricbeat modules enable system
9. If this is the first Metricbeat in our Elastic Stack Execute this command:
``` shell 
sudo metricbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.99.101:9200"]'
```
10. Start the Metricbeat service:
  - CentOS:
``` shell
sudo systemctl daemon-reload

sudo systemctl enable metricbeat

sudo systemctl start metricbeat
```
  - Ubuntu:
``` shell
sudo service metricbeat start
```