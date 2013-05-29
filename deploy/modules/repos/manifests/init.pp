class repos {

  if $osfamily == "RedHat"{
    yumrepo { 'local-vagrant':
      baseurl  => "file:///vagrant/deploy/packages",
      descr    => 'Local packages',
      gpgcheck => 0
    } ->

    yumrepo { 'puppetlabs-devel':
      baseurl  => "http://yum.puppetlabs.com/el/6/devel/x86_64",
      descr    => 'Puppet Labs Devel El 6 - x86_64',
      enabled  => '1',
      gpgcheck => '0'
    } ->

    yumrepo { 'puppetlabs-deps':
      baseurl  => "http://yum.puppetlabs.com/el/6/dependencies/x86_64",
      descr    => 'Puppet Labs Dependencies El 6 - x86_64',
      enabled  => '1',
      gpgcheck => '0'
    } ->

    yumrepo { 'puppetlabs-products':
      baseurl  => "http://yum.puppetlabs.com/el/6/products/x86_64",
      descr    => 'Puppet Labs Products El 6 - x86_64',
      enabled  => '1',
      gpgcheck => '0'
    } ->

    yumrepo { 'epel':
      descr          => 'Extra Packages for Enterprise Linux 6 - x86_64',
      enabled        => '1',
      failovermethod => 'priority',
      gpgcheck       => '0',
      mirrorlist     => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=x86_64",
    }

  }elsif $osfamily == "Debian"{
    exec{"get_repo":
      command => "/usr/bin/wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb",
      cwd => "/tmp",
    }

    exec{"install_repo":
      command => "/usr/bin/dpkg -i puppetlabs-release-precise.deb",
      cwd => "/tmp",
      require => Exec["get_repo"],
    }

    exec{"update_apt":
      command => "/usr/bin/apt-get update",
      require => Exec["install_repo"],
    }
  }

  Class["repos"] -> Package <| |>
}

