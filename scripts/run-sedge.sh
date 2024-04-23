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
  --el-extra-flag Sync.SnapSync=true \
  --el-extra-flag Sync.FastSync=true \
  >> $PWD/sedge.logs

echo "Docker compose file:"
cat docker-compose.yml

./sedge run -p . >> $HOME/sedge.logs
tail $PWD/sedge.logs
docker ps

max_attempts=10
attempt=1

while [ $attempt -le $max_attempts ]; do
    response=$(curl -s http://localhost:8545)
    if [ -n "$response" ]; then
        echo "Successfully received response: $response"
        exit 0
    else
        echo "Attempt $attempt: No response received, retrying..."
        sleep 5
        attempt=$((attempt + 1))
    fi
done

echo "Max attempts reached, failed to receive response."
exit 1
