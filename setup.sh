#!/bin/bash

# Little script to do the required setup of the namespaces

set -x

BUILD_NS=nodejs-bluegreen-build
DEV_NS=nodejs-bluegreen-dev
PROD_NS=nodejs-bluegreen-prod

# Create the namespaces
oc new-project $BUILD_NS
oc new-project $DEV_NS
oc new-project $PROD_NS

# Set up the build namespace
oc project $BUILD_NS

# create a jenkins instance
oc new-app jenkins-ephemeral \
   --param ENABLE_OAUTH=true \
   --param MEMORY_LIMIT=2Gi  \
   --param DISABLE_ADMINISTRATIVE_MONITORS=true

# set up the service account to change the dev/prod namespaces
oc policy add-role-to-user admin system:serviceaccount:$BUILD_NS:jenkins -n $DEV_NS
oc policy add-role-to-user admin system:serviceaccount:$BUILD_NS:jenkins -n $PROD_NS

# create the build configs and image stream for the application
cat manifests/build/* | oc create -f -


# set up the dev namespace
oc project $DEV_NS
cat manifests/dev/* | oc create -f -

# set up the prod namepsace
oc project $PROD_NS
cat manifests/prod/* | oc create -f -
