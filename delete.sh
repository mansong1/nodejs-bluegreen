#!/bin/bash

oc delete project nodejs-bluegreen-build --wait
oc delete project nodejs-bluegreen-dev --wait
oc delete project nodejs-bluegreen-prod --wait
