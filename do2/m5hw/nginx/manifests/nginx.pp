docker::run { 'nginx':
  image            => 'latest',
  detach           => true,
  ports            => ['80', '80'],
  expose           => ['80', '80'],
  extra_parameters => [ '--restart=always' ],
}

class { 'firewall': }

firewall { '000 accept 80/tcp':
  action   => 'accept',
  dport    => 80,
  proto    => 'tcp',
}

selboolean { 'Apache SELinux':
  name       => 'httpd_can_network_connect', 
  persistent => true, 
  provider   => getsetsebool, 
  value      => on, 
}
