node('linux') {
  cleanWs()
  //management identity Azure for session agent Docker
  sh "az login --identity"
}

pipeline {
  agent any
  }

  environment {
    env = "environment"
    AKV = "<azure-key-vault>"
    AZURE_SUBSCRIPTION_NAME = "<subscription-name>"
    AZURE_SUBSCRIPTION_ID = "<subscription-id>"
    AZURE_TENANT_ID="<tenant-id>"
  }

  stages {

    stage('Checkout Code') {

      steps {
        // checkout of the repository
        checkout([
          $class: 'GitSCM',
          branches: [[name: '*/<branch-name>']],
          userRemoteConfigs: [[url: "repository-url" ,credentialsId:'jenkins-git-credentials']]
        ])
      }
    }

    stage('Get secrets & login') {

      steps {

          // obtaining secret values and Azure login process
          script {
            sh "curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true | jq  '.access_token' > token"
            ACCESS_TOKEN = readFile('token').trim()
            ARM_CLIENT_ID = sh(returnStdout: true, script: "set +x && curl -s https://${AKV}.vault.azure.net/secrets/DeploySpClientId?api-version=2016-10-01 -H \"Authorization: Bearer ${ACCESS_TOKEN}\" | jq '.value'").trim()
            ARM_CLIENT_SECRET = sh(returnStdout: true, script: "set +x && curl -s https://${AKV}.vault.azure.net/secrets/DeploySpClientSecret?api-version=2016-10-01 -H \"Authorization: Bearer ${ACCESS_TOKEN}\" | jq '.value'").trim()
            ARM_SUBSCRIPTION_ID = sh(returnStdout: true, script: "echo $AZURE_SUBSCRIPTION_ID").trim()
            ARM_TENANT_ID = sh(returnStdout: true, script: "echo $AZURE_TENANT_ID").trim()
            sh "set +x && az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID"
          }
      }
    }
     stage('Terraform Init') {

      steps {
          script {
            // initialize terraform remote state
            sh "set +x && terraform init -backend-config=config/${env.ENVIRONMENT}.backend.tfvars -backend-config=arm_subscription_id=$ARM_SUBSCRIPTION_ID -backend-config=arm_tenant_id=$ARM_TENANT_ID"
          }
      }
    }

     stage('Terraform Plan') {

      steps {
          script {
            sh "set +x && terraform plan -var 'client_id=$ARM_CLIENT_ID' -var 'client_secret=$ARM_CLIENT_SECRET' -var 'subscription_id=$ARM_SUBSCRIPTION_ID' -var 'tenant_id=$ARM_TENANT_ID' -var-file=${env.ENVIRONMENT}.tfvars"
            }
      }
    }
    stage('Terraform Apply') {
            
      steps {
          // let user aprove terraform apply or cancel
          script {
            timeout(time: 600, unit: 'SECONDS') {
                    input message: 'Do you want to Apply Terraform?', ok: 'Apply'
            }
            // executing terraform process
            sh "set +x && terraform apply -auto-approve -var 'client_id=$ARM_CLIENT_ID' -var 'client_secret=$ARM_CLIENT_SECRET' -var 'subscription_id=$ARM_SUBSCRIPTION_ID' -var 'tenant_id=$ARM_TENANT_ID' -var-file=${env.ENVIRONMENT}.tfvars"
          }
      }
    }
  }
}
