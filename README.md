# Repo for project "CI/CD with Jenkins and Beaker" in IMT3005 - Infrastructure as Code

## Introduction

The goal of the project is to experiment with CI/CD using OpenStack, Jenkins and Beaker. I'm trying to accomplish an infrastructure with a Puppet Master, a Jenkins server and an application server that runs CI/CD on any changes made, and ultimaltely deploys them into production.  

Please see [the report](./report) for more details about the project itself.

## Structure

This repository is mainly a [control repository](https://puppet.com/docs/pe/latest/code_management/control_repo.html) based on [this template](https://github.com/puppetlabs/control-repo), but it also contains an infrastructure definition in OpenStack Heat that brings up a stack running the control-repo. The original README from the template is stored [here](./README_original.md).

Here's a visual representation of the structure of this repository:

```
imt3005-project-cicd/
├── data/                                 # Hiera data directory.
│   ├── nodes/                            # Node-specific data goes here.
│   └── common.yaml                       # Common data goes here.
├── infrastructure/                       # OpenStack Heat infrastructure definition that defines a stack running this control-repo.
├── manifests/
│   └── site.pp                           # The "main" manifest that contains a default node definition.
├── report/                               # Contains the LaTeX report
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

## Usage

I made [this Vagrant machine](https://github.com/tholok97/imt3005-vagrant-vm) for working with the project. It includes all the tools needed to work with the repo. You do however need access to an [Openstack](https://www.openstack.org/) cloud environment to deploy the stack in.

### To create the stack

1. (Either fork this repository and make r10k clone your forked repository, or alter the bootscript of manager to pull using HTTPS, not SSH. This is because you need my private Github key to clone the repository with ssh. This is an unfortunate barrier of entry, but I have not had time to fix it.)
1. Provide your own environment file based on `infrastructure/topology_env_example.yaml`. (e.g. `cp infrastructure/topology_env_example.yaml infrastructure/topology_env.yaml`, and fill it with your environment specific settings).
1. Create the stack defined in `infrastructure/topology.yaml`, and provide the environment file you made eariler. (e.g. `openstack create -t infrastructure/topology.yaml -e infrastructure/topology_env.yaml cicd_stack`)
1. Profit! The stack should configure itself. Find the floating IP address of the Jenkins server and browse to it on port 8080. When the stack is fully provisioned you will se a Jenkins server running here with a few jobs. The admin username/password is insecureAdmin/insecurePassword.

## TODO

*(WONTFIX, as project is finished)*

* Configure Blue Ocean plugin for Jenkins.
* Include security groups in infrastructure definition.
* Separate out general installation in own bootscript (to be used with CI).
* Implement missing functionality described in report.

## References

Note that this is a subset of the references found in my report.

* Beaker 101 talk: <https://www.youtube.com/watch?v=cSyJXTYFXFg>
* Beaker Github page: <https://github.com/puppetlabs/beaker>
* Blog talking about Beaker: <https://club.black.co.at/log/posts/2016-03-28-cooperating-with-travisci/>
* Talk that includes Beaker: <https://www.youtube.com/watch?v=GgNrxLfoDF8&t=1623s>
* Article about testing of control-repos: <https://www.example42.com/2017/12/18/beaker_with_vagrant_and_docker/>
* beaker-puppet docs: <https://www.rubydoc.info/gems/beaker-puppet>
* Issue corresponding to some installation trouble I ran in to: <https://tickets.puppetlabs.com/browse/BKR-821>
* Issue corersponding to some runtime trouble I ran in to: <https://tickets.puppetlabs.com/browse/BKR-1530>
* Issue corresponding to an issue I had with a plugin: <https://github.com/puppetlabs/beaker-puppet_install_helper/issues/45>
* Project that solves testing of control-repos: <https://github.com/dylanratcliffe/onceover#nodesets>
  * Article about above project: <https://puppet.com/blog/use-onceover-start-testing-rspec-puppet>
* OpenStack article about testing. Includes Beaker: <https://docs.openstack.org/puppet-openstack-guide/latest/contributor/testing.html>
* Repo about testing OpenStack (Puppet): <https://github.com/openstack/puppet-openstack-integration>
* Video about IaC testing: <https://puppet.com/resources/video/r-tyler-croy-of-jenkins-on-infrastructure-as-code-testing/thank-you>
* PDF about Puppet testing with Jenkins: <http://iopscience.iop.org/article/10.1088/1742-6596/664/6/062059/pdf>
* Control-repo on steriods: <https://github.com/example42/psick>
* JCasC video: <https://www.youtube.com/watch?v=PAKWqRE0aTk&t=82s>
* JCasC Docker image: <https://github.com/Praqma/jenkins4casc>
* Handy article about JCasC: <https://automatingguy.com/2018/09/25/jenkins-configuration-as-code/>
* Docker image for JCasC: <https://hub.docker.com/r/praqma/docker4jcasc/>
* Article about JCasC: <https://www.praqma.com/stories/start-jenkins-config-as-code/>
* Lecturer's heat definition I based my own on: <https://github.com/githubgossin/IaC-heat-cr>
* Lecturer's control-repo: <https://github.com/githubgossin/control-repo-cr>
* How to use Docker with a Pipeline: <https://jenkins.io/doc/book/pipeline/docker/>
* "Don't use docker-in-docker for CI: <http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/>
* Pretty good example of a Jenkins Dockerfile with Docker installed connected to underlying Docker: <https://github.com/shazChaudhry/docker-jenkins/blob/ee0f386fd1706829b956cb2e723c0f2935496933/Dockerfile>
* Article series about Jenkins Job-DSL and Pipelines: <https://marcesher.com/2016/08/04/jenkins-as-code-comparing-job-dsl-and-pipelines/>
* Big article about Jenkins Pipeline: <https://jenkins.io/solutions/pipeline/>
* Job-DSL plugin pipeline reference: <https://jenkinsci.github.io/job-dsl-plugin/#path/pipelineJob>
* (Very) good video about Beaker-rspec: <https://www.youtube.com/watch?v=jEJmUQOlaDg>
* Article about functional testing with Vagrant, OpenStack and Beaker: <http://my1.fr/blog/puppet-module-functional-testing-with-vagrant-openstack-and-beaker/>
  * The bootscript in the above article points to a file that looks like this: <https://github.com/openstack/puppet-keystone/blob/master/spec/acceptance/nodesets/nodepool-xenial.yml>. It defines a Beaker node with no hyporvisor, and seems to make beaker use the host machine as it's testing machine (Might do testing like this).
* OpenStack article from 2015 talking about their transition to testing their Puppet modules with Beaker: <http://specs.openstack.org/openstack-infra/infra-specs/specs/puppet-module-functional-testing.html>
* OpenStack development CI docs page: <https://docs.openstack.org/puppet-openstack-guide/latest/contributor/ci.html>
* Thread about committing changes from Jenkins: <https://stackoverflow.com/questions/38769976/is-it-possible-to-git-merge-push-using-jenkins-pipeline>
* Article about creating a continious deployment pipeline with Jenkins and Go (not well written, but it worked): <https://blog.couchbase.com/create-continuous-deployment-pipeline-golang-jenkins/>
* Example of Jenkinsfile for control-repo: <https://github.com/raj-andy1/control-repo/blob/production/Jenkinsfile>
* Article about deployment over ssh from pipeline: <https://medium.com/@weblab_tech/how-to-publish-artifacts-in-jenkins-f021b17fde71>
* Best-practises for pipeline-plugin: <https://www.cloudbees.com/blog/top-10-best-practices-jenkins-pipeline-plugin>
