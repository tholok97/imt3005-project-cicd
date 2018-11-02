# Jenkins should include base and jenkins profile
class role::jenkins {

  # All roles should include the base profile
  include ::profile::base
  include ::profile::jenkins
}
