# Rippled (node)

This container allows you to run a `rippled` node. No config required.

The server will keep a history of **only 256 ledgers**. You can change this value in the config (more about the config in this readme).

The container is configured to serve a public http websocket at port `80` and the local _rpc admin service_ in the container at port `5005`.
Other ports (443, 6006, 51235) can be mapped but should be enabled in the config first.

This container is running on `ubuntu:kinetic`.


## How to run

### From Github

If you downloaded / cloned the [Github repo](https://github.com/WietseWind/docker-rippled) you got yourself a few scripts to get started. In the `./go` folder, the following scripts are available, run:

> `go/build [username] [name] [version | latest] [production | standalone]`

- `go/build transia icv2 production` to build the production container image (tag: `rippled`)
- `go/build transia icv2 standalone` to build the standalone container image (tag: `rippled`)
- `go/up transia icv2` to create a new container named `rippled` and setup the port and persistent config (*1)
- `go/down transia icv2` to stop and remove the container `rippled`

The `go/up` command will mount the subfolder (in the cloned repo folder) `config` to the container; the `rippled.cfg` config and `validators.txt` will be loaded from this folder when `rippled` starts. If you stop/start or restart the container, the container will pickup your changes.

When starting the container the `go/up` script will map port `80` on your host to port `80` in the container. This is where `rippled` is configured to serve a websocket. If you want to run the websocket on another TCP port, you can enter the port after the `go/up` command, eg.:

```
go/up 8080
```

After spinning the container up, you will see the rippled log. You should see a lot of information show up within a few seconds. If you want to stop watching the log, press CTRL - C. The container will keep on running in the background.

If you want to build the image manually, use (you can change the tag):

`docker build --tag transia/icv2:latest --target=standalone .`

### From the Docker Hub

Use the image `transia/icv2`.

**Because you only retrieved the container image from the Docker Hub, you have to manually create a container based on the image.** When creating the container, please make sure you open port `80`.

If you run the container with a mapping to `/config/` (in the container) containing a `rippled.cfg` and `validators.txt` file, these will be used. If the mapping or these files aren't present, `rippled` will start with the default config.

This command launches your `rippled` container and the rippled websocket at port `80`:

```
docker run -dit \
    --name rippled \
    -p 80:80 \
    -v /my/local/disk/icv2-config/:/config/ \
    transia/icv2:latest
```

You can change the `--name` and **make sure you specify a valid local full path for your volume source, instead of `/my/local/disk/xrpld-config/`**.

You can fetch a working sample config from the [Github repo](https://github.com/WietseWind/docker-rippled).

## So it's running

If you want to check the rippled-logs (container stdout, press CTRL - C to stop watching):

```
docker logs -f rippled
```

If you want to check the rippled server status:

```
docker exec rippled server_info
```

Check the value of `complete_ledgers` in the server info to see if the server
has complete ledgers with transactions. When you launch the container it may take
a few minutes for the server to sync.

If you started the container manually, you may have to change the name of the container (`rippled`) to the name you entered in your `docker run` command.

## Connecting

You can now connect to the `rippled` websocket using a client like [ripple-lib](https://github.com/ripple/ripple-lib/tree/master).

# Updating

- **????-??-??** [version] [is released]()
- **2022-08-25** latest [is released](https://github.com/Transia-RnD/thehub/tree/main/amendments/icv2)

## Update process

1. Stop the container: `docker stop rippled` (if you named (`--name`) the container `rippled`)
2. Remove the container: `docker rm rippled`
3. Remove the image: `docker rmi transia/icv2:latest` (or if you built the container image based on the [Github repo](https://github.com/WietseWind/docker-rippled): use the image name you specified when building)
4. Re-create the container; if you used Git: `git pull` and `go/build` - if you used the Docker Hub: just use the command from this Readme (_From the Docker Hub_), a new version of the image will be downloaded.

**USE THE PATHS YOU SPECIFIED (`-v` argument) WHEN RECREATING THE CONTAINER IF YOU WANT TO KEEP YOUR CONFIG AND/OR DATA!**

## Building & publishing to Docker Hub:

```
version=1.8.1 # sample
docker build --no-cache --tag transia/icv2:$version .
docker push transia/icv2:$version
docker tag transia/icv2:$version transia/icv2:latest
docker push transia/icv2:latest
```