#!/bin/bash

app_name='p7zip'
pkg_name='p7zip'
app_fullname='p7zip'
version='16.02'

backup=`pwd`
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

# make executable
chmod u+x ./install.sh

# build installer -------------------------------------

for arch in i386 amd64
do

echo ""
echo "=============================================================================="
echo "Creating Installer (${arch})..."
echo "=============================================================================="
echo ""

# check for errors
if [ $? -ne 0 ]; then cd "$backup"; echo "Failed"; exit 1; fi

# make installer
cp -p --no-preserve=ownership -t ${arch} ./install.sh
makeself ${arch} ./builds/${pkg_name}-${version}-${arch}.run "${app_fullname} v${version} (${arch})" ./install.sh 

# check for errors
if [ $? -ne 0 ]; then cd "$backup"; echo "Failed"; exit 1; fi

done

cd "$backup"
