# Witness (node)

docker build -t gcr.io/metaxrplorer/comms:latest -f Dockerfile . --build-arg XCHAIN_CONFIG_DIR=app/config --build-arg RIPPLED_EXE=app/rippled --build-arg WITNESSD_EXE=app/witness

docker run --rm -it gcr.io/metaxrplorer/witness:latest

### Pull out config files

config directory

`docker cp comms:/app/config config/`

config.json

`docker cp comms:/root/.config/sidechain-cli config-sidechain/`

### Activate .venv

`. /app/sidechain-cli/.venv/bin/activate`

sidechain-cli bridge create --name=bridge --chains locking_chain issuing_chain --witness witness0 --witness witness1 --witness witness2

cat $XCHAIN_CONFIG_DIR/bridge_bootstrap.json | jq .locking_chain_door.id | tr -d '"' | xargs sidechain-cli fund --chain locking_chain --account

sidechain-cli bridge build --bridge bridge --bootstrap $XCHAIN_CONFIG_DIR/bridge_bootstrap.json --verbose

sidechain-cli fund --chain locking_chain --account raFcdz1g8LWJDJWJE2ZKLRGdmUmsTyxaym
sidechain-cli fund --chain issuing_chain --account rJdTJRJZ6GXCCRaamHJgEqVzB7Zy4557Pi

sidechain-cli bridge transfer --bridge bridge --src_chain locking_chain --amount 10000000 --from snqs2zzXuMA71w9isKHPTrvFn1HaJ --to snyEJjY2Xi5Dxdh81Jy9Mj3AiYRQM --tutorial


### Run docker compose 

`docker compose -f docker-compose.yml up --build --force-recreate -d`