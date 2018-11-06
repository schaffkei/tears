#!/bin/bash

set -e

rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $rundir/functions.i.sh

deploy_modules base cloudera
