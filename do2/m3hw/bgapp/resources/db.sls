install.mariadb.debian:
  pkg:
    - name: mariadb-server
    - installed

run.mariadb.debian:
  service.running:
    - name: mariadb
    - require:
      - pkg: mariadb-server
    - watch:
      - pkg: mariadb-server

copy_db_files:
  file.recurse:
    - name: /home/vagrant/
    - source: salt://db

open_external_ports:
  cmd.run:
    - name: sed -i.bak s/127.0.0.1/0.0.0.0/g /etc/mysql/mariadb.conf.d/50-server.cnf

create_db:
  cmd.run:
    - name: mysql -u root < /home/vagrant/db_setup.sql || true

restart_db:
  cmd.run:
    - name: sudo systemctl restart mariadb