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
  env.APP_NAME = "nodejs-blue-green"
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
        openshift.withCluster() {
          openshift.withProject(BUILD) {
            echo "Attemping to start and follow 'buildconfig/${APP_NAME}' in ${openshift.project()}"
            def buildConfig = openshift.selector('bc', APP_NAME)
            def build       = buildConfig.startBuild('--wait')
            build.logs('-f')
          }
        }
      }
    }

    stage('Promote from Build to Dev') {
      steps {
        tagImage(sourceImageName: APP_NAME, sourceImagePath: BUILD, toImagePath: DEV)
      }
    }
  }
}
