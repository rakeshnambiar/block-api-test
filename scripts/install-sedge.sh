#!/bin/bash

echo "Downloading sedge sources..."
git clone https://github.com/NethermindEth/sedge.git src --branch main --single-branch 
echo "Sources downloaded."
cd src
echo "Building sedge..."
make compile
ls -ltr
