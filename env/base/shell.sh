#! /bin/bash

set -e

rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $rundir/../functions.i.sh


update_file dot_bashrc ~/.bashrc
update_file dot_exrc ~/.exrc
update_file dot_inputrc ~/.inputrc
