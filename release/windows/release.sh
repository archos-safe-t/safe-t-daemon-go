#!/bin/sh

set -e

cd $(dirname $0)

TARGET=$1
VERSION=$(cat /release/build/VERSION)

INSTALLER=safe-t-bridge-$VERSION-$TARGET-install.exe

cd /release/build

cp /release/safe-t-daemon.nsis safe-t-daemon.nsis
cp /release/safe-t-daemon.ico safe-t-daemon.ico

SIGNKEY=/release/authenticode

if [ -r $SIGNKEY.der ]; then
    for BINARY in {safe-t-daemon,devcon,wdi-simple}-{32b,64b}.exe ; do
        mv $BINARY $BINARY.unsigned
        osslsigncode sign -certs $SIGNKEY.p7b -key $SIGNKEY.der -n "Safe-T Bridge" -i "https://safe-t.io/" -h sha256 -t "http://timestamp.comodoca.com?td=sha256" -in $BINARY.unsigned -out $BINARY
        osslsigncode verify -in $BINARY
    done
fi

if [ $TARGET = win32 ]; then
    makensis -X"OutFile $INSTALLER" -X'InstallDir "$PROGRAMFILES32\Safe-T Bridge"' safe-t-daemon.nsis
else
    makensis -X"OutFile $INSTALLER" -X'InstallDir "$PROGRAMFILES64\Safe-T Bridge"' safe-t-daemon.nsis
fi

if [ -r $SIGNKEY.der ]; then
    mv $INSTALLER $INSTALLER.unsigned
    osslsigncode sign -certs $SIGNKEY.p7b -key $SIGNKEY.der -n "Safe-T Bridge" -i "https://safe-t.io/" -h sha256 -t "http://timestamp.comodoca.com?td=sha256" -in $INSTALLER.unsigned -out $INSTALLER
    osslsigncode verify -in $INSTALLER
fi
