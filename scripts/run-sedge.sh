#!/bin/bash

pwd
ls -lr
cd src/build

echo 'Running sedge...'
./sedge deps install >> $HOME/sedge.logs
./sedge generate --logging none -p $HOME /
full-node --map-all --no-mev-boost --no-validator --network chiado /
-c lighthouse:sigp/lighthouse:latest -e nethermind:nethermindeth/nethermind:master /
--el-extra-flag Sync.NonValidatorNode=true --el-extra-flag Sync.DownloadBodiesInFastSync=false / --el-extra-flag Sync.DownloadReceiptsInFastSync=false /
--cl-extra-flag checkpoint-sync-url=http://139.144.26.89:4000/ >> $HOME/sedge.logs
./sedge run -p . >> $HOME/sedge.logs
