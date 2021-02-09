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
    stage('Test') {
      steps {
        // git url: "${APPLICATION_SOURCE_REPO}", branch: "${APPLICATION_SOURCE_REF}"
        sh '''
        npm --version
        npm install
        '''
      }
    }
  }
}
