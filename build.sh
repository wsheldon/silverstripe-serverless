#!/bin/sh
CODEBUILD_GIT_BRANCH=`git symbolic-ref HEAD --short 2>/dev/null`
if [ "$CODEBUILD_GIT_BRANCH" == "" ] ; then
  CODEBUILD_GIT_BRANCH=`git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }'`
  CODEBUILD_GIT_BRANCH=${CODEBUILD_GIT_BRANCH#remotes/origin/}
fi
serverless deploy --stage "$CODEBUILD_GIT_BRANCH" --region us-east-1 --verbose | tee deploy.out
