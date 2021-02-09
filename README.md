# nodejs-bluegreen

This is a sample project that illustrates an advanced deployment strategy 
implementation of blue-green on OpenShift.

To install/setup simply login into the cluster of interest and run

```./setup.sh```

This will provision the following namespaces:
* nodejs-bluegreen-build
* nodejs-bluegreen-dev
* nodejs-bluegreen-prod

The build namespace is where an ephemeral instance of Jenkins is deployed. 
Additionally, build configs for the application are placed here as well.
One build config is for the jenkins pipeline job, and the other is a S2I (source to image)
for the nodejs application.

```manifests/```

All of the OpenShift templates / objects are defined as YAML in this directory.
The contents of this directory are applied via `setup.sh`.

---

This project is largely based off of https://github.com/redhat-cop/container-pipelines/tree/master/blue-green-spring