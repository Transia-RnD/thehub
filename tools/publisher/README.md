Run Publisher

```
docker run --rm -it \
    --name validator \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher/keystore/publisher.json:/root/.ripple/validator-keys.json \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher:/app/publisher \
    transia/validator:latest
```

```
python3 main.py signer add JAAAAARxIe26TNdevJWWBlIDMYATAUoiF++EDehdZOS/qeEu3qb3/nMhAy3wqOh0a95SRoV35equVhOefp9piRR7b0tVUn0N3G2ndkYwRAIgU9rsfnB3ee1ZnRHGGRdFfnbSM3NBlw6SJM6tM4wLlVcCIB67N5pz5cueAVPmZo0xhw2l2CcRNzEzVmqJsY76CXmxcBJAaUneHxKMyb/0TmKP350WgxKHV0vie17kJFgTTufP3ZkjvIR96dHqICzCnGV6jKRLbN5clXTlPtwZWyju7XKpBA==
```

```
docker run --rm -it \
    --name validator \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher/keystore/node1.json:/root/.ripple/validator-keys.json \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher:/app/publisher \
    transia/validator:latest
```

```
docker run --rm -it \
    --name validator \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher/keystore/node2.json:/root/.ripple/validator-keys.json \
    -v /Users/dustedfloor/projects/transia-rnd/thehub/tools/publisher:/app/publisher \
    transia/validator:latest
```