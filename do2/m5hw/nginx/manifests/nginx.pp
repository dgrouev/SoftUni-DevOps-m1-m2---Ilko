class { 'docker': }

docker::run { 'nginx':
  image            => 'nginx:latest',
  detach           => false,
  ports            => ['80:80'],
}

class { 'firewall': }

firewall { '000 accept 80/tcp':
  action   => 'accept',
  dport    => 80,
  proto    => 'tcp',
}
