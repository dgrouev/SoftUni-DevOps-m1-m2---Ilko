# Homework M7: Elastic Stack

## REST API Index Patter Creation
1. Send POST request with curl
``` shell
curl -XPOST http://192.168.99.101:5601/api/index_patterns/index_pattern -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "index_pattern": {
     "title": "hello"
  }
}'
```

* Alternative
``` shell
curl -XPOST "http://localhost:5601/api/saved_objects/_import?overwrite=true" -H "kbn-xsrf: true" --form file=@elastiflow.kibana.8.6.x.ndjson
```

