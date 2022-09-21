# Witness (node)

docker build -t gcr.io/metaxrplorer/xrpld-witness:latest -f Dockerfile . --build-arg XCHAIN_CONFIG_DIR=app/config --build-arg RIPPLED_EXE=app/rippled --build-arg WITNESSD_EXE=app/witness

docker run 