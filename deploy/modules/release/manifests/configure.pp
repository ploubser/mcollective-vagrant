class release::configure($user = "vagrant"){

  if $osfamily == "RedHat"{
    file{"/home/$user/rpmbuild/":
      ensure => "directory",
      owner => $user,
      mode => "0744",
    } ->

    file{"/home/$user/rpmbuild/BUILD":
      ensure => "directory",
      owner => $user,
      mode => "0744",
    } ->
  
    file{"/home/$user/rpmbuild/RPMS":
      ensure => "directory",
      owner => $user,
      mode => "0744",
    } ->
  
    file{"/home/$user/rpmbuild/SOURCES":
      ensure => "directory",
      owner => $user,
      mode => "0744",
    } ->
  
    file{"/home/$user/rpmbuild/SPECS":
      ensure => "directory",
      owner => $user,
      mode => "0744",
    } ->
  
    file{"/home/$user/rpmbuild/SRPMS":
      ensure => "directory",
      owner => $user,
      mode => "0744",
    }
  }
}
