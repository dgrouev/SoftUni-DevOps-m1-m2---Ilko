# Homework M7: Elastic Stack

## REST API Index Patter Creation
1. Send POST request with curl
``` shell
curl -X POST "localhost:5601/api/index_patterns/index_pattern" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "index_pattern": {
      "id": "...",
      "version": "...",
      "title": "...",
      "type": "...",
      "timeFieldName": "...",
      "sourceFilters": [],
      "fields": {},
      "typeMeta": {},
      "fieldFormats": {},
      "fieldAttrs": {},
      "runtimeFieldMap": {}
      "allowNoIndex": "..."
    }
}
'
```
