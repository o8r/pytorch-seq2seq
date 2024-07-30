#!/usr/bin/bash

## Usage: postCreateCommand.sh <workspaceFolder>
WORKSPACE_FOLDER=$1
CONFDIR="$WORKSPACE_FOLDER/.devcontainer/conf"
if [ -d "$CONFDIR" ]; then
    for f in `find $CONFDIR -maxdepth 1 -type f`; do
        BASENAME=`basename $f`
        sed -r s~'\$\{?\s*WORKSPACE_FOLDER\s*\}?'~"${WORKSPACE_FOLDER}"~g $f >> ~/$BASENAME
    done
fi

source ~/.bash_profile
set

# Pip proxy settings
if [ -n "$HTTP_PROXY" ]; then
    PIP_PROXY="--proxy $HTTP_PROXY"
    if [ -n "$PIP_CERT" ]; then
        pip config set global.cert $PIP_CERT
    fi
else
    PIP_PROXY=""
fi

# timeout setting for pip (in seconds)
PIP_TIMEOUT=30
if [ -n "PIP_TIMEOUT" ]; then
  PIP_TIMEOUT="--timeout $PIP_TIMEOUT"
fi

# Install pipenv
pip install $PIP_PROXY $PIP_TIMEOUT pipenv

# Create pipenv environment
cd $WORKSPACE_FOLDER
pipenv --python 3.6
pipenv install -r requirements.txt

# Install
cd $WORKSPACE_FOLDER
pipenv run python setup.py install

#apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
#apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
