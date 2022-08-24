# XRPL Sidechain Hub

The Hub is a central location to hold sidechain builds and validation files. Each sidechain/amendment has its own directory inside the hub.

> The reason the hub exists is because we need to run tests in a standalone enviroment for each ammendment.

## Create new ammendment or sidechain in the hub

1. Copy the template directory in `template`.
2. Rename the directory to match the rippled branch name. ie. `hooks` -> `hooks`.
3. Configure your `rippled.cfg` file to include the amendment.
4. Create a pull request.

> XRPLF will review and then add the following to the daily build script.

To build the debug image manually make sure you are logged into docker and run the following;

`./build_hub --docker=transia --genesis --github=https://github.com/XRPLF/rippled.git --branch=amm`

This will produce the following: `docker.io/transia/amm:genesis`.

> It might be preferrable to add `--local` flag to the command to build the docker locally.

For production you would remove the --genesis flag and this would produce: `docker.io/transia/amm:latest`.


Tools/Builders:

We prebuild the dependencies depending on what type of build you need to do. The options are;

debug: Will build a debug version of rippled for testing
release: will build a release version of rippled for production

Misc Commands:

Enter into docker builder for testing.

`docker run --rm -it transia/builder:1.75.0`