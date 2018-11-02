# Manager is currently empty. 
# Has puppetserver and r10k installed from bootstrapping
class role::manager {

  # All roles should include the base profile
  include ::profile::base

}
