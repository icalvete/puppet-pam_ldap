class pam_ldap::params {

  $ldap_hosts      = hiera('ldap_hosts')
  $ldap_suffix     = hiera('ldap_suffix')
  $ldap_admin_user = hiera('ldap_admin_user')
  $ldap_admin_pass = hiera('ldap_admin_pass')

  $pam_sshd        = '/etc/pam.d/sshd'
  $pam_pass_type   = 'md5'

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
      $package       = ['libpam-ldap', 'libnss-ldap', 'nslcd']
      $pam_system_auth_ac = '/etc/pam.d/login'
      $pam_ldap_file = 'ldap.conf'
    }
    /^(CentOS|RedHat)$/:{
      $package            = ['nss-pam-ldapd', 'pam_ldap']
      $pam_system_auth_ac = '/etc/pam.d/system-auth-ac'
      $pam_ldap_file      = 'pam_ldap.conf'
    }
    default: {
      fail("Operating system $operatingsystem is not supported")
    }
  }
}

