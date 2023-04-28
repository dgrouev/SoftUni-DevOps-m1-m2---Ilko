# Creating NGINX container with Chef


## Prerequisites
1. Prepare the CentOS machines to use Chef by executing the following commands:
``` shell
sudo dnf install -y chrony
sudo systemctl enable chronyd
sudo systemctl start chronyd
sudo setenforce permissive
sudo sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux
```

## Server Installation
1. Start SSH seesion to the server and prepare Chef server by executing the following commands:
``` shell
wget -P /tmp https://packages.chef.io/files/stable/chef-server/15.6.2/el/8/chef-server-core-15.6.2-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-server-core-15.6.2-1.el8.x86_64.rpm
sudo chef-server-ctl reconfigure
sudo chef-server-ctl user-create chefadmin Chef Admin chefadmin@do2.lab 'Password1' --filename /home/vagrant/chefadmin.pem
sudo chef-server-ctl org-create demo-org 'Demo Org.' --association_user chefadmin --filename /home/vagrant/demoorg-validator.pem
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload 
```

## Steps for Chef Automate:
1. Execute the following commands on the server:
``` shell
curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate
sudo ./chef-automate init-config
sudo vi config.toml
```

2. Paste the contents below in the **config.toml** file and save:
``` ini
[elasticsearch.v1.sys.runtime]
heapsize = "2g"
```

3. Stop Chef-Server and Deploy **Chef Automate** by executing:
``` shell
sudo chef-server-ctl stop
sudo ./chef-automate deploy config.toml
```

4. If the preflight-check fail, do the following steps:
``` shell
sudo vi /etc/sysctl.conf
```

5. Paste the following contents inside the **sysctl.conf** file and save:
``` ruby
vm.dirty_expire_centisecs=20000
```

6. Execute the following command to fix the system tuning failures:
``` shell
sudo sysctl -w vm.dirty_expire_centisecs=20000
```



## Workstation installation
3. Start another session to workstation machine and install Chef-Workstation and Git by executing the following commands:
``` shell
wget -P /tmp https://packages.chef.io/files/stable/chef-workstation/23.4.1032/el/8/chef-workstation-23.4.1032-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-workstation-23.4.1032-1.el8.x86_64.rpm
sudo dnf install -y git
```

4. Configure the Ruby provided by Chef:
``` shell
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
echo 'export PATH="/opt/chef-workstation/embedded/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
```

## Configuring Knife
1. Start by executing the following command on the workstation machine:
``` shell
knife configure
```

2. Please enter the chef server URL: [https://chef-wrkstn/organizations/myorg]
``` shell
https://192.168.99.101/organizations/demo-org
```

3. Please enter an existing username or clientname for the API: [vagrant]
``` shell
chefadmin
```

4. Switch to the server machine, navigate to the home folder and execute the following command:
``` shell
scp chefadmin.pem vagrant@chef-wrkstn:/home/vagrant/.chef/chefadmin.pem
```

5. Type **yes** and press Enter

## Start Nginx Container

0. Add Git Credentials by replacing **email** and **name** with yours:
``` sheel
git config --global user.email "<email>"
git config --global user.name "<name>"
```

1. Create Nginx Cookbook:
``` shell
chef generate cookbook container
```

6. Add the following line to container/metadata.rb:
```
depends 'docker', '~> 2.0'
```

7. Edit the default recipe container/recipes/default.rb to the following contents:
``` ruby
docker_service 'default' do
  action [:create, :start]
end

docker_image 'mycontainer' do
  tag 'latest'
  action :pull
end

docker_container 'mycontainer' do
  repo 'nginx'
  tag 'latest'
  port '80:80'
end
```

8. Start the container with:
``` shell
chef-run localhost nginx/recipes/default.rb --user vagrant --password vagrant
```