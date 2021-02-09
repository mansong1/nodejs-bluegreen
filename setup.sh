#!/bin/bash

# Little script to do the required setup of the namespaces

set -x

BUILD_NS=nodejs-bluegreen-build
DEV_NS=nodejs-bluegreen-dev
PROD_NS=nodejs-bluegreen-prod


oc new-project $BUILD_NS
oc new-project $DEV_NS
oc new-project $PROD_NS

oc project $BUILD_NS
oc new-app jenkins-ephemeral \
   --param ENABLE_OAUTH=true \
   --param MEMORY_LIMIT=2Gi  \
   --param DISABLE_ADMINISTRATIVE_MONITORS=true

oc policy add-role-to-user admin system:serviceaccount:$BUILD_NS:jenkins -n $DEV_NS
oc policy add-role-to-user admin system:serviceaccount:$BUILD_NS:jenkins -n $PROD_NS


oc create -f manifests/*