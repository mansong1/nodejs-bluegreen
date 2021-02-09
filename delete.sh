#!/bin/bash

oc delete project nodejs-bluegreen-build
oc delete project nodejs-bluegreen-dev
oc delete project nodejs-bluegreen-prod
