pipeline {
  agent { label 'sidious' }
  options {
    timestamps()
    buildDiscarder(logRotator(artifactDaysToKeepStr: '10', artifactNumToKeepStr: '20', daysToKeepStr: '20', numToKeepStr: '20'))
    disableConcurrentBuilds()
  }
  environment {
    JENKINS_BUILD = 'true'
  }
  parameters {
    string(name: 'CR_BRANCH', defaultValue: "master", description: 'Cordova 2048 branch and/or tag to use to compile. (Git tag but must be formatted as "refs/tags/{tagName}")')
    string(name: 'sdk_build_number', defaultValue: '', description: 'Build number for SDK-Framework to use for artifacts.')
  }
  stages {
    stage ('Checking out branch and setting up environment') {
      steps {
        script {
          checkout([$class: 'GitSCM', branches: [[name: '${CR_BRANCH}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CleanCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'git@github.com:skillz/2048-Cordova.git']]])
          configFileProvider([configFile(fileId: 'd355cd90-e5a7-47d3-84f0-d14d5acda8c3', targetLocation: '../../../../../../opsadmin/.gradle/gradle.properties'), configFile(fileId: 'd355cd90-e5a7-47d3-84f0-d14d5acda8c3', targetLocation: 'platforms/android/gradle.properties')]) {}
        }
      }
    }
    stage ('Copy Skillz Framework Artifacts') {
      steps {
        script {
          copyArtifacts filter: '**/Skillz.framework.zip,**/Skillz.framework.dSYM.zip,**/Skillz_DEBUG.framework.zip,**/Skillz_DEBUG.framework.dSYM.zip', fingerprintArtifacts: true, flatten: true, projectName: '../SDK-Framework/SDK-Framework-Zinc', selector: specific('${sdk_build_number}')
        }
      }
    }
    stage ('Build iOS and Android Apps') {
      failFast true
      parallel {
        stage ('Build iOS') {
          steps {
            script {
              sh '''
                sh ./bin/build-cordova-2048-ios.sh
              '''
            }
          }
        }
        stage ('Build Android') {
          steps {
            script {
              sh '''
                sh ./bin/build-cordova-2048-android.sh
              '''
            }
          }
        }
      }
    }
    stage ('Archive Artifacts') {
      steps {
        archiveArtifacts '**/**.apk, **/**.xcarchive.zip, **/**.ipa, *.zip'
      }
    }
  }
}
