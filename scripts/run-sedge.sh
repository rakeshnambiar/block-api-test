#!/bin/bash
max_attempts=30
count=0
until sudo docker info > /dev/null 2>&1 || [ $count -eq $max_attempts ]; do
    echo "Waiting for Docker to be up and running in the loop (Attempt $((count+1)) of $max_attempts)"
    sleep 1
    ((count++))
done

if sudo docker info > /dev/null 2>&1; then
    echo "Docker is up and running"
else
    echo "Docker did not start after $max_attempts attempts"
    exit 1
fi

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
