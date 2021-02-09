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

Dev only has a simple set-up for running one version of the application at a time.

Prod has a complex deployment allowing for two versions of the application to run
at the same time to enable a blue/green methodology. To achieve this, there is 
DeploymentConfig, Route and Service for each color. The currently live color is
selected by the colorless route.  The colorless route simply points to either
the green route or the blue route.

The image streams are created implicitly when we copy / promote them from 
environment to environment.


```manifests/```

All of the OpenShift templates / objects are defined as YAML in this directory.
The contents of this directory are applied via `setup.sh`.

---

This project is largely based off of https://github.com/redhat-cop/container-pipelines/tree/master/blue-green-spring