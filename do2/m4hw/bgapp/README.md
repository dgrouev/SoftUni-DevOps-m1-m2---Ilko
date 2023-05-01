# BGApp deployment with Chef

## Prerequisites for all CentOS machines
1. Prepare the CentOS machines to use Chef by executing the following commands:
``` shell
sudo dnf install -y chrony
sudo systemctl enable chronyd
sudo systemctl start chronyd
sudo setenforce permissive
sudo sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux
```

2. Do only this for the Debian (db) Machine:
``` shell
sudo apt-get install -y ntp
```

## Server Installation
1. Start SSH seesion to the server and prepare Chef server by executing the following commands:
``` shell
wget -P /tmp https://packages.chef.io/files/stable/chef-server/15.6.2/el/8/chef-server-core-15.6.2-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-server-core-15.6.2-1.el8.x86_64.rpm
sudo chef-server-ctl reconfigure --chef-license accept
sudo chef-server-ctl user-create chefadmin Chef Admin chefadmin@do2.lab 'Password1' --filename /home/vagrant/chefadmin.pem
sudo chef-server-ctl org-create demo-org 'Demo Org.' --association_user chefadmin --filename /home/vagrant/demoorg-validator.pem
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload
```

2. Install Chef-Manage by executing the following:
``` shell
sudo chef-server-ctl install chef-manage
sudo chef-server-ctl reconfigure
sudo chef-manage-ctl reconfigure
```

3. Open the browser and navigate to http://192.168.99.101

4. Login with user **chefadmin** and password **Password1**

5. Go to the **Administration** tab and download the **Starter Kit**

## Web machine installation
1. Start SSH session to the web machine

2. Install the Prerequisites (look at the top of this file)

3. Install Chef and git with:
``` shell
wget -P /tmp https://packages.chef.io/files/stable/chef-workstation/23.4.1032/el/8/chef-workstation-23.4.1032-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-workstation-23.4.1032-1.el8.x86_64.rpm
sudo dnf install -y git
```

4. Use the Ruby provided by Chef by executing:
``` shell
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
echo 'export PATH="/opt/chef-workstation/embedded/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
```

5. Bring the chef-starter.zip from the host machine with, **yes to fingerprint** and **vagrant** for password (Execute from your Host machine):
``` shell
scp <path-to-chef-starter.zip> vagrant@192.168.99.102:.
```

6. Unzip the chef-starter.zip with:
``` shell
unzip chef-starter.zip
```

7. Go inside chef-repo folder and connect to the server with:
``` shell
cd chef-repo
knife ssl fetch
```

8. Add Web and Db nodes to Chef-Server with:
``` shell
knife bootstrap 192.168.99.102 -N web -U vagrant -P vagrant --sudo
knife bootstrap 192.168.99.103 -N db -U vagrant -P vagrant --sudo
```

## Web machine cookbook

1. Go to Starter cookbook with:
``` shell
cd ~/chef-repo/cookbooks/starter/
```

2. Generate **site** resource with:
``` shell
chef generate resource . site
```

3. vi resources/site.rb:
``` ruby
provides :site

action :create do
  package %w(httpd php php-mysqlnd mysql)
  service "httpd" do
    action [:enable, :start]
  end

  remote_directory "/var/www" do
    source 'default/var/www'
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

  execute "restart httpd service" do
    command "sudo systemctl restart httpd"
    user "root"
  end
end

```

4. vi recipes/default.rb:
``` ruby
site 'custom-site' do
  action :create
end
```

5. Copy the resources to the files/default folder with:
``` shell
cp -R /vagrant/resources/var files/default/
```

6. Upload the recipe on the server with:
``` shell
knife cookbook upload starter
```

7. Add the recipe to the web machine run-list with:
``` shell
knife node run_list add web "recipe[starter]"
```

8. Execute the recipe with:
``` shell
sudo chef-client
```

## Db machine cookbook
1. Go back to cookbooks folder with:
``` shell
cd ~/chef-repo/cookbooks/starter/
```

2. Generate DB cookbook with:
``` shell
chef generate cookbook db
```

3. Copy the resources to the DB cookbook with:
``` shell
cp -R ~/chef-repo/cookbooks/starter/files/* ~/chef-repo/cookbooks/db/files
```

4. Paste the following contents inside recipes/default.rb of the Db cookbook:
``` ruby
execute "Update package indexes" do
  command "apt-get update"
  user "root"
end

 package "mariadb-server"

 service "mariadb" do
   action [:enable, :start]
 end

 remote_directory "/home/vagrant/db" do
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
  command "mysql --default-character-set=utf8 -u root < /home/vagrant/db/db_setup.sql || true"
  user "root"
end

execute "Restart MariaDB" do
  command "sudo systemctl restart mariadb"
  user "root"
end
```


5. Add the cookbook to the run list of the db client with:
``` shell
knife node run_list add db "recipe[db]"
```

6. Start an SSH session to the db machine and execute:
``` shell
sudo chef-client
```


7. The BGApp should be successfully deployed on http://192.168.99.102


