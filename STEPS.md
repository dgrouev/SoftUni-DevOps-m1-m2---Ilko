1. Start Redis in Bridge Network **IBK-Bridge**
``` shell
docker run -d --name redis-stack -p 6379:6379 --network IBK-Bridge redis/redis-stack-server:latest
```

2. Navigate to Listener's Folder
``` shell
cd /var/www/vhosts/greybox.ai/dev.greybox.ai/htdocs/listener
```

3. Make sure to rebuild every time a change is made to the scripts for the changes to take effect
``` shell
docker build -t ibk-listener .
```

4. Start the Listener container on port 5000 connected to the Bridge Network to ensure it can see Redis and the rest of the Stack
``` shell
docker run -p 5000:5000 --network IBK-Bridge ibk-listener
```