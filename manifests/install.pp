class pam_ldap::install {

  package {$pam_ldap::params::package:
    ensure => present
  }
}
