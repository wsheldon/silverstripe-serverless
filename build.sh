#!/bin/sh
CODEBUILD_GIT_BRANCH=`git symbolic-ref HEAD --short 2>/dev/null`
if [ "$CODEBUILD_GIT_BRANCH" == "" ] ; then
  CODEBUILD_GIT_BRANCH=`git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }'`
  CODEBUILD_GIT_BRANCH=${CODEBUILD_GIT_BRANCH#remotes/origin/}
fi
composer update
composer vendor-expose copy
aws s3 sync public/_resources s3://wilsonsheldon.name/_resources
serverless deploy --stage "$CODEBUILD_GIT_BRANCH" --verbose | tee deploy.out
