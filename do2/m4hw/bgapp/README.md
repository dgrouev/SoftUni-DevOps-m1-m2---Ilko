vi cookbooks/starter/resources/site.rb:
``` ruby
provides :site

if node['platform_family'] == 'debian'
  vpackage = 'apache2'
else
  vpackage = 'httpd'
end

action :create do
  package %w(php php-mysqlnd mysql)
  package "#{vpackage}"
  service "#{vpackage}" do
    action [:enable, :start]
  end

  remote_directory "/var/www" do
    source 'var/www'
    files_owner 'vagrant'
    files_group 'vagrant'
    files_mode '0644'
    action :create
    recursive true
    overwrite true
  end

  execute "" do
    command "sudo firewall-cmd --add-port=80/tcp --permanent && sudo firewall-cmd --reload"
    user "root"
  end

  execute "enable_httpd_in_selinux" do
    command "setsebool -P httpd_can_network_connect=1"
    user "root"
  end
end

action :delete do
  package "#{vpackage}" do
    action :remove
  end
  file '/var/www/html/*' do
    action :delete
  end
end
```

vi cookbooks/starter/recipes/default.rb:
``` ruby
site 'custom-site' do
  action :create
end
```

tree
.
├── cookbooks
│   ├── chefignore
│   └── starter
│       ├── attributes
│       │   └── default.rb
│       ├── files
│       │   └── default
│       │       ├── sample.txt
│       │       ├── var
│       │       │   └── www
│       │       │       └── html
│       │       │           ├── bulgaria-map.png
│       │       │           └── index.php
│       │       └── web
│       ├── metadata.rb
│       ├── recipes
│       │   └── default.rb
│       ├── resources
│       │   └── site.rb
│       └── templates
│           └── default
│               └── sample.erb
├── nodes [error opening dir]
├── README.md
└── roles
    └── starter.rb

## Install on Client
1. Upload the cookbook with:
``` shell
knife cookbook upload starter
```

2. Successful upload should print this in your console:
```
Uploading starter      [1.0.0]
Uploaded 1 cookbook.
```

3. Add the cookbooc to the run list of the web client with:
``` shell
knife node run_list add web "recipe[starter]"
```

4. Successful adding to the run-list should print this in your console:
client-1:
  run_list: recipe[starter]

5. Execute **sudo chef-client** on the web client machine

## DB Setup

1. Move the db_setup.sql to workstation machine with from the host machine being in the db parent folder:
``` shell
scp db/db_setup.sql vagrant@192.168.99.104:/home/vagrant/chef-repo/cookbooks/starter/files/default/db/db_setup.sql
```

2. recipes/default.rb contents:
``` ruby
execute "Update package indexes" do
  command "apt-get update"
  user "root"
end

 package "mariadb-server"

 service "mariadb" do
   action [:enable, :start]
 end

 remote_directory "db" do
   source 'db'
   files_owner 'vagrant'
   files_group 'vagrant'
   files_mode '0644'
   action :create
   recursive true
   overwrite true
 end

execute "Allow external connection to DB" do
  command "sed -i.bak s/127.0.0.1/0.0.0.0/g /etc/mysql/mariadb.conf.d/50-server.cnf"
  user "root"
end

execute "Create database reading db_setup.sql" do
  command "mysql --default-character-set=utf8 -u root < /home/vagrant/db_setup.sql || true"
  user "root"
end

execute "Restart MariaDB" do
  command "sudo systemctl restart mariadb"
  user "root"
end
```

tree
.
├── cookbooks
│   ├── chefignore
│   ├── db
│   │   ├── CHANGELOG.md
│   │   ├── chefignore
│   │   ├── compliance
│   │   │   ├── inputs
│   │   │   ├── profiles
│   │   │   ├── README.md
│   │   │   └── waivers
│   │   ├── files
│   │   │   └── db
│   │   │       └── db_setup.sql
│   │   ├── kitchen.yml
│   │   ├── LICENSE
│   │   ├── metadata.rb
│   │   ├── Policyfile.rb
│   │   ├── README.md
│   │   ├── recipes
│   │   │   └── default.rb
│   │   └── test
│   │       └── integration
│   │           └── default
│   │               └── default_test.rb