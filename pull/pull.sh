#!/bin/bash

git rev-parse --is-inside-work-tree # timeout=10
git config remote.origin.url git://github.com/davidwalter0/transform # timeout=10
git --version # timeout=10
git -c core.askpass=true fetch --tags --progress git://github.com/davidwalter0/transform +refs/heads/*:refs/remotes/origin/*
git rev-parse refs/remotes/origin/master^{commit} # timeout=10
COMMIT=$(git rev-parse refs/remotes/origin/origin/master^{commit}) # timeout=10
git config core.sparsecheckout # timeout=10
git checkout -f ${COMMIT}

