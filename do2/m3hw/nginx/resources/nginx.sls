install.common.packages:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
  pip.installed:
    - pkgs:
      - docker

docker-repo:
  pkgrepo.managed:
    - humanname: Docker Officia
    - name: docker-ce-stable
    - baseurl: https://download.docker.com/linux/centos/{{ grains['osmajorrelease'] }}/x86_64/stable
    - gpgkey: https://download.docker.com/linux/centos/gpg
    - gpgcheck: 1
    - enabled: 1

docker:
  pkg.installed:
    - refresh: True
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    - aggregate: False

run.docker:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker

nginx_container:
  docker_container.running:
    - image: nginx
    - name: mynginx
    - skip_translate: port_bindings
    - port_bindings: {80: 80}