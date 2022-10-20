Run Publisher

```
docker run --rm -it \
    --name validator \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher/keystore/publisher.json:/app/publisher/keystore/publisher.json \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher:/app/publisher \
    transia/validator:latest
```

```
docker run --rm -it \
    --name validator \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher/keystore/node1.json:/app/publisher/keystore/node1.json \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher:/app/publisher \
    transia/validator:latest
```

```
docker run --rm -it \
    --name validator \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher/keystore/node2.json:/app/publisher/keystore/node2.json \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher:/app/publisher \
    transia/validator:latest
```