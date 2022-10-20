# XRPL Sidechain Hub Cont.

Tag:

[branch] [version]

`./tag.sh icv2 latest`

Release:

[docker] [branch] [version] [directory]

`./release.sh gcr.io/metaxrplorer xchain latest amendments`

Tools/Builders:

We prebuild the dependencies depending on what type of build you need to do. The options are;

debug: Will build a debug version of rippled for testing
release: will build a release version of rippled for production

To build a dependency repo you will need access to cloud build.

Misc Commands:

`docker build --platform=linux/amd64 --tag transia/witness:latest -f builder/witness.dockerfile .`

`docker build --tag transia/ccache:latest -f builder/ccache.dockerfile .`

`docker cp xrpld-genesis:latest:/var/log/rippled/debug.log debug.log`

Enter into docker builder for testing.

`docker run --rm -it transia/builder:1.75.0`

`docker run --rm -it gcr.io/metaxrplorer/ccache:latest`

`docker run -d -it --name icv2 gcr.io/metaxrplorer/icv2:latest`

`docker run --rm -it --name validator gcr.io/metaxrplorer/validator:base`

`docker run -d -it -p 3000:3000 --name explorer transia/explorer`

`docker cp validator:/root/.ripple/validator-keys.json keystore/publisher.json`

`docker cp validator:/root/.ripple/validator-keys.json validation/validator-keys.json`

Manually Extract rippled exe

```
docker run -d -it --name rippled xrpllabsofficial/xrpld:latest && \
docker cp rippled:/app/rippled ~/projects/transia-rnd/thehub/amendments/releases/testnet-rippled && \
docker stop rippled
```

Prune Docker:

`docker builder prune`

`docker system prune`

Tag regex (Cloud Build):

`^icv2:((\d+\.)?(\d+\.)?(\*|\d+)|latest)$`

Tag other:

`git push --delete origin icv2-latest || git tag icv2-latest && git push origin --tags`

# ARG IMAGE
# FROM ${IMAGE} AS builder