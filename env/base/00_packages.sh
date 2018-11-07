#!/bin/bash

set -e 

if ! which aws >/dev/null 2>&1
then
	if ! which pip >/dev/null 2>&1
	then
		curl -O https://bootstrap.pypa.io/get-pip.py | python
	fi

	pip install awscli
fi
