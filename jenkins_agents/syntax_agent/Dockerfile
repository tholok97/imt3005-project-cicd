FROM ubuntu:18.04
MAINTAINER tholok97 thomahl@stud.ntnu.no

# add puppetlabs repo
RUN apt-get update
RUN apt-get -y install curl
RUN curl -o /tmp/puppet5-release-bionic.deb https://apt.puppetlabs.com/puppet5-release-bionic.deb
RUN dpkg -i /tmp/puppet5-release-bionic.deb
RUN apt-get update

# install puppet-agent (comes with puppet parser validate, which is what we want) and puppet-lint
RUN apt-get -y update && apt-get -y install puppet-agent puppet-lint
