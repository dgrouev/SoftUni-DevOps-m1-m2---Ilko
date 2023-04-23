install.web.packages:
  pkg.installed:
    - pkgs:
      - php
      - php-mysqlnd
      - mysql

install.apache.redhat:
  pkg:
    - name: httpd
    - installed

copy_web_files:
  file.recurse:
    - name: /var/www/html
    - source: salt://html

publicc:
  firewalld.present:
    - name: public
    - services:
      - http

firewalld:
  service.running:
    - watch:
      - firewalld: public

httpd_can_network_connect:
  selinux.boolean:
    - value: True
    - persist: True

run.apache.redhat:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:
      - pkg: httpd