# Runs jenkins inside a container and configures it using Jenkins Configuration as Code
# Currently just a demonstration that installation and configuration works. Configuration 
#  is taken from below link. This class will be cleaned up later (Move ugly 'content' 
#  declarations to files, remove unnecessary plugins, etc).
# Heavily inspired by:
# * https://github.com/Praqma/praqma-jenkins-casc (config taken from here)
# * https://www.praqma.com/stories/start-jenkins-config-as-code/
# * https://github.com/Praqma/jenkins4casc
class profile::jenkins {

  include 'docker'

  # create dockerfile 
  file { '/tmp/Dockerfile':
    ensure  => 'present',
    source => 'puppet:///modules/profile/jenkins_dockerfile',
  }

  # create image from dockerfile
  docker::image { 'jenkins_image':
    docker_file => '/tmp/Dockerfile',
    subscribe   => File['/tmp/Dockerfile'],
  }

  # create dir tree for below janky solution
  file { [ '/var/', '/var/lib/', '/var/lib/docker/', '/var/lib/docker/volumes/', 
           '/var/lib/docker/volumes/jenkins_home/', '/var/lib/docker/volumes/jenkins_home/_data/' ]:
    ensure => 'directory',
  }

  # make sure jenkins.yaml file for JCasC is correct.
  # TODO: this is a janky solution.. There is probably a better way of injecting our 
  #       config file into our running container. Do I even need volumes here?
  file { '/var/lib/docker/volumes/jenkins_home/_data/jenkins.yaml':
    ensure => 'present',
    source => 'puppet:///modules/profile/jenkins.yaml',
  }

  # run the container, and make sure it restarts whenever the image it's based on or the jenkins.yaml 
  # config file changes.
  #
  # TODO: should jenkins_home have a volume? (for logs, etc.)
  # TODO: container shouldn't have to restart when the config file changes, as JCasC can reload it's config while 
  #       jenkins is running
  docker::run { 'jenkins_container':
    image      => 'jenkins_image',
    ports      => ['8080:8080', '50000:50000'],
    volumes    => [ 'jenkins_home:/var/jenkins_home/jenkins.yaml' ],
    env        => ['CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml'],
    subscribe  => [ Docker::Image['jenkins_image'], File['/var/lib/docker/volumes/jenkins_home/_data/jenkins.yaml'] ]
  }
}
