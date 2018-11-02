pipeline {
  agent none
  stages {
    stage('puppet parser validate') {
      agent {
        // using dockerfile defined
        dockerfile {
          dir 'jenkins_agents/syntax_agent/'
        }
      }
      steps {
        sh '/opt/puppetlabs/bin/puppet parser validate --debug --verbose .'
      }
    }
    stage('puppet-lint') {
      agent {
        // using dockerfile defined
        dockerfile {
          dir 'jenkins_agents/syntax_agent/'
        }
      }
      steps {
        sh '/usr/bin/puppet-lint --error-level all --fail-on-warnings .'
      }
    }
    stage('r10k deploy') {
      agent none
      steps {
        sh "ssh -o StrictHostKeyChecking=no root@manager.borg.trek 'r10k deploy environment -p --verbose'"
      }
    }
  }
}
