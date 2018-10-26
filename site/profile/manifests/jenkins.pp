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

  # have to add Docker to the official Jenkins Docker image:
  file { '/home/ubuntu/praqma-jenkins-casc/plugins_extra.txt':
    ensure  => present,
    content => '
credentials:2.1.17
git:3.9.0
ssh-slaves:1.26
warnings:4.66
matrix-auth:2.3
job-dsl:1.70
workflow-aggregator:2.5
timestamper:1.8.9
github-oauth:0.29
pretested-integration:3.0.1
envinject:2.1.6
text-finder:1.10
email-ext:2.62
slack:2.3
parameterized-trigger:2.35.2
copyartifact:1.41
htmlpublisher:1.16
  ',
  }

  # have to add Docker to the official Jenkins Docker image:
  file { '/tmp/Dockerfile2':
    ensure  => present,
    content => '
FROM praqma/jenkins4casc:1.0

LABEL maintainer="man@praqma.net"
#COPY plugins_extra.txt /usr/share/jenkins/ref/plugins_extra.txt

ARG JAVA_OPTS

# TEMPORARY SOLUTION BECAUSE HAVE PROBLEMS WITH COPYING OVER FILE ABOVE
RUN /usr/local/bin/install-plugins.sh credentials:2.1.17 git:3.9.0 ssh-slaves:1.26 warnings:4.66 matrix-auth:2.3 job-dsl:1.70 workflow-aggregator:2.5 timestamper:1.8.9 github-oauth:0.29 pretested-integration:3.0.1 envinject:2.1.6 text-fi
nder:1.10 email-ext:2.62 slack:2.3 parameterized-trigger:2.35.2 copyartifact:1.41 htmlpublisher:1.16

#RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins_extra.txt
  ',
  }

  # create image from Dockerfile
  docker::image { 'jenkins2':
    docker_file => '/tmp/Dockerfile2',
    subscribe   => File['/tmp/Dockerfile2'],
  }


  # run the container
  docker::run { 'jenkins2':
    image      => 'jenkins2',
    ports      => ['8081:8080', '50001:50000'],
    volumes    => [ '/home/ubuntu/praqma-jenkins-casc/jenkins.yaml:/var/jenkins_home/jenkins.yaml' ],
    env        => ['CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml'],
    subscribe  => Docker::Image['jenkins2'],
  }
}
