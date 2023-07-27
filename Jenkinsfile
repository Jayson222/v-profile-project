pipeline {
    agent any 
    tools {
        maven "MAVEN3"
        jdk "openjdk8"
    }    
    
    environment {
        SNAP_REPO = 'vprofile-snapshot'
        NEXUS_USER = 'admin'
        NEXUS_PASS = 'admin'
        RELEASE_REPO = 'vprofile-release'
        CENTRAL_REPO = 'vprofile-mvn-central'
        NEXUSIP = '54.169.200.96'
        NEXUSPORT = '8081'
        NEXUS_GRP_REPO = 'vpro-maven-group'
        NEXUS_LOGIN = 'nexuslogin'
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
         

    }

    stages {
        stage ('Build'){
            steps {
            sh 'mvn -s settings.xml -DskipTests install'
        }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war' 
                }
            }
        }

        stage('Test'){
            steps {
                sh 'mvn test'
            }
        }

        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn -s settings.xml  checkstyle:checkstyle'
            }
        }
    

        stage('Sonar Analysis') {
             environment {
                 scannerHome = tool "${SONARSCANNER}"
          }
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                   sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }  
            }
        
        } 

        stage("Upload Artifact") {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                    groupId: 'QA',
                    version: "${env.BUILD_ID}-${env.BUIL_TIMESTAMP}",
                    repository: "${RELEASE_REPO}",
                    credentialsId: "${NEXUS_LOGIN}",
                    artifacts: [
                      [artifactId: 'vproapp',
                        classifier: '',
                        file: 'target/vprofile-v2.war',
                        type: 'war']
                    ]
                )         
            }
        }

        stage("Deploy On Tomcat") {
            steps {
                sshagent(['tomcattoken']) {
                sh 'scp -o StrictHostKeyChecking=no target/vprofile-v2.war ec2-user@13.229.232.128:/opt/tomcat9/webapps' }

            }
        
        }
            
    }       
}
