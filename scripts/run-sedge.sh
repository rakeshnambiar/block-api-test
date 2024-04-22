#!/bin/bash

echo "Home directory: $HOME"
cd src/build
echo 'Running sedge...'
./sedge generate --logging none \
  -p . full-node \
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

#echo "Current directory:${pwd}"
#cp $HOME/docker-compose.yml .
#cp $HOME/.env .
#cat docker-compose.yml
#echo "Copied docker-compose file"
#ls -lta
./sedge run -p . >> $HOME/sedge.logs
curl http://localhost:8545/