library identifier: "pipeline-library@v1.5",
retriever: modernSCM(
  [
    $class: "GitSCMSource",
    remote: "https://github.com/redhat-cop/pipeline-library.git"
  ]
)

def currentState = 'green'
def newState = 'blue'
def version = ''

openshift.withCluster() {
  env.COLORLESS_APP_NAME = 'nodejs'
  env.APP_NAME = "nodejs-bluegreen"
  env.BUILD = openshift.project()
  env.DEV = "${APP_NAME}-dev"
  env.STAGE = "${APP_NAME}-stage"
  env.PROD = "${APP_NAME}-prod"
  echo "Starting Pipeline for ${APP_NAME}..."
}

pipeline {
  agent {
    label 'nodejs'
  }

  stages {
    stage('Build') {
      steps {
        sh '''
        npm --version
        '''
      }
    }

    stage('s2i - Build Container Image') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject(BUILD) {
              echo "Attemping to start and follow 'buildconfig/${APP_NAME}' in ${openshift.project()}"
              def buildConfig = openshift.selector('bc', APP_NAME)
              def build = buildConfig.startBuild()
              build.logs('-f')
            }
          }
        }
      }
    }

    stage('Promote from Build to Dev') {
      steps {
        tagImage(sourceImageName: APP_NAME, sourceImagePath: BUILD, toImagePath: DEV)
      }
    }

    stage('Verify Deployment to Dev') {
      steps {
        verifyDeployment(projectName: DEV, targetApp: APP_NAME)
      }
    }

    stage('Promote from Dev to Prod') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject(PROD) {
              def activeService = openshift.selector("route/${APP_NAME}").object().spec.to.name
              if (activeService == "${COLORLESS_APP_NAME}-blue") {
                newState = 'green'
                currentState = 'blue'
              }
              def dc = openshift.selector("dc/${COLORLESS_APP_NAME}-${newState}").object()
              def trigger_patch =  [
                ["type":"ImageChange",
                 "imageChangeParams":[
                   "automatic": true,
                   "containerNames": ["${COLORLESS_APP_NAME}-${newState}"],
                   "from":[
                     "kind":"ImageStreamTag",
                     "namespace":PROD,
                     "name":"${COLORLESS_APP_NAME}-${newState}:${version}"
                   ]
                 ]
                ],
                ["type":"ConfigChange"]
              ]
              dc.spec.triggers = trigger_patch
              openshift.apply(dc)
            }
          }
        }
        tagImage(
          sourceImageName: APP_NAME
          , sourceImagePath: DEV
          , toImagePath: PROD
          , toImageName: "${COLORLESS_APP_NAME}-${newState}"
          , toImageTag: version
        )
      }
    }
    
    stage('Verify Deployment to Prod') {
      steps {
        verifyDeployment(projectName: PROD, targetApp: "${COLORLESS_APP_NAME}-${newState}")
      }
    }
    
    stage('Switch route to new version') {
      steps {
        script {
          input "Switch ${PROD} from ${currentState} to ${newState} deployment?"
          openshift.withCluster() {
            openshift.withProject(PROD) {
              def route = openshift.selector("route/${APP_NAME}").object()
              route.spec.to.name = "${COLORLESS_APP_NAME}-${newState}"
              openshift.apply(route)
            }
          }
        }
      }
    }
  }
}
