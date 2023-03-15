echo "* Starting Grafana 8.2.0 as container on port 3000"
docker run -d -p 3000:3000 --name grafana grafana/grafana-oss:8.2.0