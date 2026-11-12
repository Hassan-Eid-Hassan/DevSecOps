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
                sh "mvn package install"
            }
        }
        stage('Vulnerability Scan') {
            steps {
                sh 'mvn dependency-check:check'
            }
            post {
                always {
                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
                }
            }
        }
        // stage('OWASP Dependency-Check Vulnerabilities') {
        //     steps {
        //         dependencyCheck additionalArguments: ''' 
        //                     -o './'
        //                     -s './'
        //                     -f 'ALL' 
        //                     --prettyPrint''', odcInstallation: '12.1.0'
        //         dependencyCheckPublisher pattern: 'dependency-check-report.xml'
        //     }
        // }
        stage("Test App"){
            steps{
               sh "mvn test"
            }
        }
        stage("Archive Jar"){
            steps{
                archiveArtifacts artifacts: 'target/*.jar', followSymlinks: false
                recordCoverage(tools: [[parser: 'JACOCO']],
                    id: 'jacoco', name: 'JaCoCo Coverage',
                    sourceCodeRetention: 'LAST_BUILD')
            }
        }
        stage('Mutation Tests - PIT') {
            steps {
                sh 'mvn org.pitest:pitest-maven:mutationCoverage'
            }
            post {
                always {
                    pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
                }
            }
        }
        // stage("Build Docker Image"){
        //     steps{
        //         sh "docker build -t hassaneid/depi-java:v${BUILD_NUMBER} ."
        //     }
        // }
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