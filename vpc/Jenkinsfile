pipeline {

  agent {
    node { label 'workstation' }
  }

  parameters {
    string(name: 'APPLY_ENV', defaultValue: 'dev', description: 'On which env you want to run?')
  }

  options {
    ansiColor('xterm')
  }

    stages {

      stage('Create Release') {
        when {
          expression {
            GIT_BRANCH == "main"
          }
        }
        steps {
          script {
            def statusCode = sh script:"git ls-remote --tags origin | grep \$(cat VERSION | sed -e 's|#|v|')", returnStatus:true
            if (statusCode == 0) {
              error "VERSION is already tagged, Use new version number"
            } else {
              sh '''
                mkdir temp 
                GIT_URL=$(echo $GIT_URL | sed -e "s|github.com|${TOKEN}@github.com|")
                cd temp
                git clone $GIT_URL .
                TAG=$(cat VERSION | grep "^#[0-9].[0-9].[0-9]" | head -1|sed -e "s|#|v|")
                git tag $TAG 
                git push --tags                  
              '''
            }
          }
        }
      }

      stage('Terraform Init') {
        steps {
          sh 'terraform init -backend-config=env-${APPLY_ENV}/backend.tfvars'
        }
      }

      stage('Terraform Plan') {
        steps {
          sh 'terraform plan -var-file=env-${APPLY_ENV}/main.tfvars'
          sh 'env'
        }
      }

      stage('Terraform Apply') {
        when {
          beforeInput true
          expression {
            GIT_BRANCH == "main"
          }
        }
        input {
          message "Approve for Apply?"
          ok "Approve"
          submitter "admin"
        }
        steps {
          sh 'terraform apply -auto-approve -var-file=env-${APPLY_ENV}/main.tfvars'
        }
      }

    }

}

//