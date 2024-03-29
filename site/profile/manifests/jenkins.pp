# Runs jenkins inside a container and configures it using Jenkins 
# Configuration as Code
# Heavily inspired by:
# * https://github.com/Praqma/praqma-jenkins-casc (config taken from here)
# * https://www.praqma.com/stories/start-jenkins-config-as-code/
# * https://github.com/Praqma/jenkins4casc
class profile::jenkins {

  include 'docker'

  # create dockerfile 
  file { '/tmp/Dockerfile':
    ensure => 'present',
    source => 'puppet:///modules/profile/jenkins_dockerfile',
  }

  # create image from dockerfile
  docker::image { 'jenkins_image':
    docker_file => '/tmp/Dockerfile',
    subscribe   => File['/tmp/Dockerfile'],
  }

  # create dir tree for below janky solution
  file { [ '/var/', '/var/lib/', '/var/lib/docker/', '/var/lib/docker/volumes/',
          '/var/lib/docker/volumes/jenkins_home/',
          '/var/lib/docker/volumes/jenkins_home/_data/' ]:
    ensure => 'directory',
  }

  # make sure jenkins.yaml file for JCasC is correct.
  # TODO: this is a janky solution.. There is probably a better way of 
  #       injecting our config file into our running container. Do I even 
  #       need volumes here?
  file { '/var/lib/docker/volumes/jenkins_home/_data/jenkins.yaml':
    ensure => 'present',
    source => 'puppet:///modules/profile/jenkins.yaml',
  }

  # run the container, and make sure it restarts whenever the image it's based 
  # on or the jenkins.yaml config file changes.
  # 
  # /etc/hosts and /root/.ssh/id_rsa are shared with the host machine so that 
  # configuration from stack creation process propogates into jenkins container. 
  # Probably bad, and will fix if I get the time
  #
  # TODO: should jenkins_home have a volume? (for logs, etc.)
  # TODO: container shouldn't have to restart when the config file changes, as 
  #       JCasC can reload it's config while jenkins is running
  docker::run { 'jenkins_container':
    image     => 'jenkins_image',
    ports     => ['8080:8080', '50000:50000'],
    volumes   => [ 'jenkins_home:/var/jenkins_home/jenkins.yaml',
                    '/home/ubuntu/.ssh/id_rsa:/root/.ssh/id_rsa',
                    '/etc/hosts:/etc/hosts',
                    '/var/run/docker.sock:/var/run/docker.sock' ],
    env       => ['CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml'],

    # If I don't run the container as user root jenkins is not allowed to alter 
    # it's containers.
    #
    # ^ Meaning if I remove user root Jenkins can build and run agent containers
    #   just fine, but it is not allowed to make changes in there
    #
    # TODO: If I could find a way around this issue that would be awesome
    username  => 'root',
    subscribe => [
      Docker::Image['jenkins_image'],
      File['/var/lib/docker/volumes/jenkins_home/_data/jenkins.yaml']
    ],
  }
}
