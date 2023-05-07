class { 'docker': }

docker::run { 'nginx':
  image            => 'nginx:latest',
  detach           => false,
  ports            => '80',
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
