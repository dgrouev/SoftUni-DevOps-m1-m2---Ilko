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