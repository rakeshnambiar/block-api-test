#!/bin/bash

echo "Home directory: $HOME"
cd src/build
echo 'Running sedge...'
./sedge generate --logging none \
  -p $PWD full-node \
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
  >> $PWD/sedge.logs

echo "Docker compose file:"
cat docker-compose.yml

./sedge run -p . >> $HOME/sedge.logs
tail $PWD/sedge.logs
sleep 10
docker compose -f docker-compose.yml ps --filter status=running