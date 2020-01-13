# deploy

## redis

```sh
docker run -d \
    -p 6379:6379 \
    --name redis-server \
    -v /usr/redis/data:/data \
    --restart always redis \
    --requirepass "admin" \
    --appendonly yes
```

## rabbitmq

```sh
docker run -d \
    --name rabbitmq-server \
    -p 15672:15672 -p 5672:5672 \
    --restart always \
    -v /var/lib/rabbitmq:/var/lib/rabbitmq \
    -v /var/log/rabbitmq/:/var/log/rabbitmq \
    -e RABBITMQ_DEFAULT_USER=sdc \
    -e RABBITMQ_DEFAULT_PASS=sdc \
    daocloud.io/rabbitmq:3-management
```

## mongodb

```sh
  docker run -d -p 27017:27017 \
  -v /usr/mongo/data/configdb:/data/configdb \
  -v /usr/mongo/data/db:/data/db \
  --restart=always \
  --name mongo \
  docker.io/mongo
```
