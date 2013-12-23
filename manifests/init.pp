class pam_ldap (

  $active_directory = false

) inherits pam_ldap::params {

  if $active_directory {
    $pam_pass_type = 'ad'
  } else {
    $pam_pass_type = $pam_ldap::params::pam_pass_type
  }

  anchor {'pam_ldap::begin':
    before => Class['pam_ldap::install']
  }
  class {'pam_ldap::install':
    require => Anchor['pam_ldap::begin']
  }
  class {'pam_ldap::config':
    require => Class['pam_ldap::install'],
    notify  => Class['pam_ldap::service']
  }
  class {'pam_ldap::service':
    require => Class['pam_ldap::config']
  }
  anchor {'pam_ldap::end':
    require => Class['pam_ldap::service']
  }
}
