#!/bin/sh

set -e

cd $(dirname $0)

TARGET=$1
VERSION=$(cat /release/build/VERSION)

INSTALLER=safe-t-bridge-$VERSION-$TARGET-install.exe

cd /release/build

cp /release/safe-t-daemon.nsis safe-t-daemon.nsis
cp /release/safe-t-daemon.ico safe-t-daemon.ico

CODESIGN='osslsigncode'
SIGNKEY="../archos_authenticode.p12"
SIGNPSWD="../archos_authenticode_pass.txt"
SIGN=true

if [ -z $CODESIGN ]; then
  echo "no sign tool detected. Skipping signing"
  SIGN=false
fi
if [ ! -f $SIGNKEY ]; then
  echo "no cert file found. Skipping signing "
  SIGN=false
fi
if [ ! -f $SIGNPSWD ]; then
  echo "no password file found. Skipping signing"
  SIGN=false
fi

if [ $SIGN = true ]; then
    for BINARY in {safe-t-daemon,devcon,wdi-simple}-{32b,64b}.exe ; do
        mv $BINARY $BINARY.unsigned
        $CODESIGN sign -pkcs12 $SIGNKEY -readpass $SIGNPSWD -n "Safe-T Bridge" -i "https://safe-t.io/" -h sha2 -t http://timestamp.digicert.com -in $BINARY.unsigned -out $BINARY
        $CODESIGN verify -in $BINARY
    done
fi

if [ $TARGET = win32 ]; then
    makensis -X"OutFile $INSTALLER" -X'InstallDir "$PROGRAMFILES32\Safe-T Bridge"' safe-t-daemon.nsis
else
    makensis -X"OutFile $INSTALLER" -X'InstallDir "$PROGRAMFILES64\Safe-T Bridge"' safe-t-daemon.nsis
fi

if [ $SIGN = true ]; then
    mv $INSTALLER $INSTALLER.unsigned
    $CODESIGN sign -pkcs12 $SIGNKEY -readpass $SIGNPSWD -n "Safe-T Bridge" -i "https://safe-t.io/" -h sha2 -t http://timestamp.digicert.com -in $INSTALLER.unsigned -out $INSTALLER
    $CODESIGN verify -in $INSTALLER
fi

