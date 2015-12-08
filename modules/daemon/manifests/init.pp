define daemon (
  $binary,
  $args = '',
  $user = 'root',
  $stop_timeout = 20,
) {

  Service {
    provider => $::service_provider,
  }

  service { $title:
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  if ($::service_provider == 'debian') {
    sysvinit::script { $title:
      content => template("${module_name}/sysvinit.sh.erb"),
      notify  => Service[$title],
    }

    File <| title == $binary or path == $binary |> {
      before => Sysvinit::Script[$title],
    }
  }

  if ($::service_provider == 'systemd') {
    systemd::unit { $title:
      content => template("${module_name}/systemd.service.erb"),
      notify  => Service[$title],
    }

    File <| title == $binary or path == $binary |> {
      before => Systemd::Unit[$title],
    }
  }

}
