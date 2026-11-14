pipeline{
    agent{
        label "agent-01"
    }
    tools {
      maven 'maven-3-5-4'
      jdk 'jdk-11'
    }

    environment {
        DOCKER_USER = credentials("docker-username")
        DOCKER_PASS = credentials("docker-passwd")
    }

    
    stages{
        stage("Build App"){
            steps{
                sh "mvn package install -DskipTests"
            }
        }
        stage("Scan filesystem for vulnerabilities"){
            steps{
                sh '''
                    trivy -q fs $WORKSPACE
                '''
            }
        }
        // stage('SonarQube Analysis') {
        //     steps {
        //         withSonarQubeEnv('sonarqube') {
        //             sh "mvn clean verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=devsecops -Dsonar.projectName='devsecops'"
        //         }
        //         timeout(5) {
        //             withSonarQubeEnv('sonarqube') {
        //                 waitForQualityGate abortPipeline: true, credentialsId: 'sonar-sa'
        //             }
        //         }
        //     }
        // }
        // stage("Test App"){
        //     steps{
        //        sh "mvn test"
        //     }
        // }
        // stage("Archive Jar"){
        //     steps{
        //         archiveArtifacts artifacts: 'target/*.jar', followSymlinks: false
        //         recordCoverage(tools: [[parser: 'JACOCO']],
        //             id: 'jacoco', name: 'JaCoCo Coverage',
        //             sourceCodeRetention: 'LAST_BUILD')
        //     }
        // }
        // stage('Mutation Tests - PIT') {
        //     steps {
        //         sh 'mvn org.pitest:pitest-maven:mutationCoverage'
        //     }
        //     post {
        //         always {
        //             pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        //         }
        //     }
        // }
        stage("Dockerfile OPA"){
            steps{
                sh "docker run --rm -v \"$WORKSPACE\":/workspace -w /workspace openpolicyagent/conftest test --policy dockerfile-security.rego Dockerfile"
            }
        }
        stage("Scan Base Docker Image"){
            steps{
                sh '''
                    dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
                    echo $dockerImageName
                    docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.76.2 -q image --severity HIGH,CRITICAL $dockerImageName
                '''
            }
        }
        stage("Build Docker Image"){
            steps{
                sh "docker build -t hassaneid/depi-java:v${BUILD_NUMBER} ."
            }
        }
        stage("Scan Final Docker Image"){
            steps{
                sh '''
                    docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.76.2 -q image --exit-code 1 --severity HIGH,CRITICAL hassaneid/depi-java:v${BUILD_NUMBER}
                '''
            }
        }
        // stage("Docker Login"){
        //     steps{
        //         sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
        //     }
        // }
        // stage("Docker push"){
        //     steps{
        //         sh "docker push hassaneid/depi-java:v${BUILD_NUMBER}"
        //     }
        // }
    }

    post {
        success {
            echo "success"
        }
        failure {
            echo "failure"
        }
    }

}