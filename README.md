# XRPL Sidechain Hub

The Hub is a central location to hold sidechain builds and validation files. Each sidechain/amendment has its own directory inside the hub.

> The reason the hub exists is because we need to run tests in a standalone environment for each amendment. 

## Create new ammendment or sidechain in the hub

1. Fork this repository
2. Copy the template directory in `template` and paste the dir into either amendments or sidechains.
3. Rename the directory to match the rippled branch name EXACTLY. ie. `hooks` -> `hooks`.
4. Configure your `rippled.cfg` file to include the amendment.
5. Create a pull request. Include the version, rippled branch and repository if different than XRPLF/rippled.

> Someone will review and once approved it is added to the build process.

5. Receive a build confirmation. `gcr.io/metaxrplorer/icv2:latest`
6. Receive a deploy confirmation. Must have setup with Transia. We dont deploy yet.
7. Changes to the repo/branch you provided would trigger a build. (SOON)

<!-- To build the debug image manually make sure you are logged into docker and run the following;

`./build_hub --docker=transia --genesis --github=https://github.com/XRPLF/rippled.git --branch=amm`

This will produce the following: `docker.io/transia/amm:genesis`.

> It might be preferrable to add `--local` flag to the command to build the docker locally.

For production you would remove the --genesis flag and this would produce: `docker.io/transia/amm:latest`. -->


Tools/Builders:

We prebuild the dependencies depending on what type of build you need to do. The options are;

debug: Will build a debug version of rippled for testing
release: will build a release version of rippled for production

Misc Commands:

`docker build --platform=linux/amd64 --tag transia/xrpld-witness:latest -f builder/witness.dockerfile .`

Enter into docker builder for testing.

`docker run --rm -it transia/builder:1.75.0`

`docker run -d -it --name icv2 gcr.io/metaxrplorer/icv2:latest`

`docker run --rm -it gcr.io/metaxrplorer/icv2:latest`

Manually Extract rippled exe

```
docker run -d -it --name rippled xrpllabsofficial/xrpld:latest && \
docker cp rippled:/app/rippled ~/projects/transia-rnd/thehub/amendments/releases/testnet-rippled && \
docker stop rippled
```

Tag:

[branch] [version]

`./tag.sh icv2 latest`

Release:

[docker] [branch] [version] [directory]

`./release.sh gcr.io/metaxrplorer xchain latest amendments`

Prune Docker:

`docker builder prune`

Tag regex (Cloud Build):

`^icv2:((\d+\.)?(\d+\.)?(\*|\d+)|latest)$`

Tag other:

`git push --delete origin icv2-latest || git tag icv2-latest && git push origin --tags`