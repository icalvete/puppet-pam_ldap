class pam_ldap::service {

  service {'nslcd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }

  service {'nscd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Service['nslcd']
  }
}

