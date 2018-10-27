# Repo for project "CI/CD with Jenkins and Beaker" in IMT3005 - Infrastructure as Code

## The Project

### The goal

The goal of the project is to experiment with CI/CD using OpenStack, Jenkins and Beaker. I'm trying to accomplish an infrastructure with a Puppet Master, a Jenkins server and an application server that runs CI/CD on any changes made, and ultimaltely deploys them into production.  

### Current state

* `openstack create` brings up a stack with a running Puppet Master, Jenkins server and (currently empty) application server. All configured through this control-repo using `manifests/site.pp`
* The Jenkins server is configured through [Jenkins Configuration as Code](https://jenkins.io/projects/jcasc/), but the configuration currently has nothing to do with my project. I will rewrite it with jobs for my CI/CD pipelines and so on in the future.
* **TODO**: Figure out what provider to use for Beaker. Vagrant+virtualbox doesn't seem like a viable option, so left with either [beaker-openstack](https://github.com/puppetlabs/beaker-openstack) or [vagrant-openstack-provider](https://github.com/ggiamarchi/vagrant-openstack-provider).
* **TODO**: Figure out what kind of app the application server should run.
* **TODO**: Configure Jenkins with appropriate jobs.
* **TODO**: Configure Blue Ocean plugin for Jenkins.

## About this repository

This repository is mainly a [control repository](https://puppet.com/docs/pe/latest/code_management/control_repo.html) based on [this template](https://github.com/puppetlabs/control-repo), but it also contains an infrastructure definition in OpenStack Heat that brings up a stack running the control-repo. The original README from the template is stored [here](./README_original.md).

**Currently I make all changes directly to production**. This is to keep it simple while I get the thing up and running. I'll try and switch to another workflow once CI/CD is working.

Instructions on how to use this repository will be added once it is somewhat stable.

Here's a visual representation of the structure of this repository:

```
imt3005-project-cicd/
├── data/                                 # Hiera data directory.
│   ├── nodes/                            # Node-specific data goes here.
│   └── common.yaml                       # Common data goes here.
├── infrastructure/                       # OpenStack Heat infrastructure definition that defines a stack running this control-repo.
├── manifests/
│   └── site.pp                           # The "main" manifest that contains a default node definition.
├── scripts/
│   ├── code_manager_config_version.rb    # A config_version script for Code Manager.
│   ├── config_version.rb                 # A config_version script for r10k.
│   └── config_version.sh                 # A wrapper that chooses the appropriate config_version script.
├── site/                                 # This directory contains site-specific modules and is added to $modulepath.
│   ├── profile/                          # The profile module.
│   └── role/                             # The role module.
├── LICENSE
├── Puppetfile                            # A list of external Puppet modules to deploy with an environment.
├── README.md
├── environment.conf                      # Environment-specific settings. Configures the moduelpath and config_version.
└── hiera.yaml                            # Hiera's configuration file. The Hiera hierarchy is defined here.
```

## References

*I write the below list as I go, so it's bound to be a little messy. I'll clean up towards the end of the project.*

* beaker 101 talk: <https://www.youtube.com/watch?v=cSyJXTYFXFg>
* beaker github: <https://github.com/puppetlabs/beaker>
* blog som prater om beaker: <https://club.black.co.at/log/posts/2016-03-28-cooperating-with-travisci/>
* talk om bl. a. beaker: <https://www.youtube.com/watch?v=GgNrxLfoDF8&t=1623s>
* artikkel om testing av control-repo: <https://www.example42.com/2017/12/18/beaker_with_vagrant_and_docker/>
* beaker-puppet docs: <https://www.rubydoc.info/gems/beaker-puppet>
* issue som omhandler installasjonstrøbbel jeg har: <https://tickets.puppetlabs.com/browse/BKR-821>
* issue som omhandler runtime trøbbel jeg har: <https://tickets.puppetlabs.com/browse/BKR-1530>
* issue som omhandler noe jeg slet med: <https://github.com/puppetlabs/beaker-puppet_install_helper/issues/45>
* prosjekt som løser testing av control-repo: <https://github.com/dylanratcliffe/onceover#nodesets>
    * artikkel om over: <https://puppet.com/blog/use-onceover-start-testing-rspec-puppet>
* openstack artikkel om testing (inkluderer beaker): <https://docs.openstack.org/puppet-openstack-guide/latest/contributor/testing.html>
* lovende repo med testing rundt openstack (mtp. puppet): <https://github.com/openstack/puppet-openstack-integration>
* video om iac testing: <https://puppet.com/resources/video/r-tyler-croy-of-jenkins-on-infrastructure-as-code-testing/thank-you>
* pdf om puppet testing med jenkins: <http://iopscience.iop.org/article/10.1088/1742-6596/664/6/062059/pdf>
* control-repo on steroids: <https://github.com/example42/psick>
* jenkins config as code video: <https://www.youtube.com/watch?v=PAKWqRE0aTk&t=82s>
* jcasc docker image: <https://github.com/Praqma/jenkins4casc>
* handy article about jcasc: <https://automatingguy.com/2018/09/25/jenkins-configuration-as-code/>
* docker image for jcasc: <https://hub.docker.com/r/praqma/docker4jcasc/>
* artikkel om jcasc: <https://www.praqma.com/stories/start-jenkins-config-as-code/>
* Lecturer's heat definition I based my own on: <https://github.com/githubgossin/IaC-heat-cr>
* Lecturer's control-repo: <https://github.com/githubgossin/control-repo-cr>
* How to use Docker with a Pipeline: <https://jenkins.io/doc/book/pipeline/docker/>
* "don't use docker-in-docker for CI: <http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/>
* Pretty good example of a Jenkins Dockerfile with Docker installed connected to underlying Docker: <https://github.com/shazChaudhry/docker-jenkins/blob/ee0f386fd1706829b956cb2e723c0f2935496933/Dockerfile>
* Article series about Jenkins job-dsl and pipelines: <https://marcesher.com/2016/08/04/jenkins-as-code-comparing-job-dsl-and-pipelines/>
* Big article about jenkins Pipeline: <https://jenkins.io/solutions/pipeline/>
* Job-dsl plugin pipeline reference: <https://jenkinsci.github.io/job-dsl-plugin/#path/pipelineJob>
