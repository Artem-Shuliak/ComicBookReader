#!/bin/sh

# PATH in new macOS versions doesn't include path below where rdlint is installed
export PATH=$PATH:/usr/local/bin

if which rdlint > /dev/null; then
    rdlint swiftlint
else
    echo "error: rdlint is not installed. Follow instructions here: https://github.com/readdle/rdlint"
    exit 1
fi
