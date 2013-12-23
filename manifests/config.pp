class pam_ldap::config {

  file{'nslcd.conf':
    ensure  => present,
    path    => '/etc/nslcd.conf',
    content => template("${module_name}/nslcd_${::osfamily}.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0600'
  }

  file{$pam_ldap::params::pam_ldap_file:
    ensure  => present,
    path    => "/etc/${pam_ldap::params::pam_ldap_file}",
    content => template("${module_name}/pam_ldap_${::osfamily}.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0640'
  }

  file{'nsswitch.conf':
    ensure  => present,
    path    => '/etc/nsswitch.conf',
    source  => "puppet:///modules/${module_name}/nsswitch_${::osfamily}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0640'
  }

  case $::operatingsystem {
    /^(CentOS|RedHat)$/:{
      exec {'enableldapauth':
        command => '/usr/sbin/authconfig --enableldapauth --update',
        unless  => "/bin/grep ldap ${pam_ldap::params::pam_system_auth_ac}",
        require => File['nslcd.conf', $pam_ldap::params::pam_ldap_file, 'nsswitch.conf'],
        before  => Exec['pam_system_auth_ac_mkhomedir', 'pam_sshd_mkhomedir']
      }
    }
    default:{}
  }

  exec {'pam_system_auth_ac_mkhomedir':
    command  => "/bin/echo 'session     required      pam_mkhomedir.so skel=/etc/skel/ umask=0022' >> ${pam_ldap::params::pam_system_auth_ac}",
    provider => shell,
    unless   => "/bin/grep mkhomedir ${pam_ldap::params::pam_system_auth_ac}",
  }

  exec {'pam_sshd_mkhomedir':
    command  => "/bin/echo 'session     required      pam_mkhomedir.so skel=/etc/skel/ umask=0022' >> ${pam_ldap::params::pam_sshd}",
    provider => shell,
    unless   => "/bin/grep mkhomedir ${pam_ldap::params::pam_sshd}",
  }
}
