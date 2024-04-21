#!/bin/bash

sudo service docker start
sudo docker info
until sudo docker info > /dev/null 2>&1; do
    echo "waiting for docker up and running in the loop"
    sleep 1
done

cd src/build

echo 'Running sedge...'
./sedge generate --logging none \
  -p $HOME full-node \
  --map-all \
  --no-mev-boost \
  --no-validator \
  --network chiado \
  -c lighthouse:sigp/lighthouse:latest \
  -e nethermind:nethermindeth/nethermind:master \
  --el-extra-flag Sync.NonValidatorNode=true \
  --el-extra-flag Sync.DownloadBodiesInFastSync=false \
  --el-extra-flag Sync.DownloadReceiptsInFastSync=false \
  --cl-extra-flag checkpoint-sync-url=http://139.144.26.89:4000/ \
  >> $HOME/sedge.logs
  
./sedge run -p . >> $HOME/sedge.logs
