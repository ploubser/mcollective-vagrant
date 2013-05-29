class release::install{
  package{"git":
    ensure => latest,
  }
  
  exec{"mco_clone":
    command => "/usr/bin/git clone $mco_repo",
    user    => $user,
    cwd     => "/home/$user",
    require => Package["git"],
    creates => "/home/$user/marionette-collective",
  }

  exec{"mco_checkout":
    command => "/usr/bin/git checkout -b $mco_branch origin/$mco_branch",
    user    => $user,
    cwd     => "/home/$user/marionette-collective",
    require => Exec["mco_clone"],
    unless  => "/usr/bin/git branch |grep $mco_branch",
  }

  exec{"mco-service-agent":
    command => "/usr/bin/git clone git://github.com/puppetlabs/mcollective-service-agent.git",
    user    => $user,
    cwd     => "/home/$user",
    require => Package["git"],
    creates => "/home/$user/mcollective-service-agent",
  }

  if $osfamily == "RedHat"{
    package{["redhat-lsb", "rpm-build", "redhat-rpm-config"]:
      ensure => latest,
    }
  }elsif $osfamily == "Debian"{
    package{["devscripts", "build-essential", "debhelper", "dpatch", "cdbs"]:
      ensure => latest,
    }
  }

  package{"make":
    ensure => latest,
  }

  package{"gcc":
    ensure => latest,
  }
}
