# Witness (node)

docker build -t gcr.io/metaxrplorer/witness:base -f Dockerfile . --build-arg XCHAIN_CONFIG_DIR=app/config --build-arg RIPPLED_EXE=app/rippled --build-arg WITNESSD_EXE=app/witness