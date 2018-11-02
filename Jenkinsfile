pipeline {
  agent {
    // using dockerfile defined
    dockerfile {
        dir 'jenkins_agents/syntax_agent/'
    }
  }
  stages {
    # will be removed
    stage('Testingtesting') {
      steps {
        sh 'echo "koko"'
      }
    }
    stage('puppet parser validate') {
      steps {
        sh '/opt/puppetlabs/bin/puppet parser validate --debug --verbose .'
      }
    }
    stage('puppet-lint') {
      steps {
        sh '/usr/bin/puppet-lint --error-level all --fail-on-warnings .'
      }
    }
  }
}
