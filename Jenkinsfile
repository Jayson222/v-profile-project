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
        NEXUSIP = '3.0.97.98'
        NEXUSPORT = '8081'
        NEXUS_GRP_REPO = 'vpro-maven-group'
        NUXUS_LOGIN = 'nexuslogin'
        SONAESRVER = 'sonarserver'
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
    }

    stage('CODE ANALYSIS with SONARQUBE') {
          
		  environment {
             scannerHome = tool "${SONARSCANNER}"
          }
    }
            steps {
                withSonarQubeEnv("{SONARSERVER}") {
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