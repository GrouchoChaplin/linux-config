#!/bin/env bash 

__JSIGSigFWTarget="${1:-JSIGSignaturesFramework}"

echo "Clone JSIGSignaturesFramework to: " "${__JSIGSigFWTarget}"
git clone ssh://git@bitbucket.di2e.net:7999/jsig/jsigsignaturesframework.git "${__JSIGSigFWTarget}"
