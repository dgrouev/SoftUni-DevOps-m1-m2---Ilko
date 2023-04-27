# Creating NGINX container with Chef

1. Prepare the workstation by executing the following commands:
``` shell
sudo dnf install -y chrony
sudo systemctl enable chronyd
sudo systemctl start chronyd
sudo setenforce permissive
sudo sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux
```

2. Install Chef by executing the following commands:
``` shell
wget -P /tmp https://packages.chef.io/files/stable/chef-server/15.6.2/el/8/chef-server-core-15.6.2-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-server-core-15.6.2-1.el8.x86_64.rpm
```

3. Install Chef-Workstation and Git by executing the following commands:
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

5. Create Nginx Cookbook:
``` shell
chef generate cookbook nginx
```

6. Add the following line to nginx/metadata.rb:
```
depends 'docker', '~> 2.0'
```

7. Edit the default recipe nginx/recipes/default.rb to the following contents:
``` ruby
docker_service 'default' do
  action [:create, :start]
end

docker_image 'nginx' do
  tag 'latest'
  action :pull
end

docker_container 'nginx' do
  repo 'nginx'
  tag 'latest'
  port '80:80'
end
```

8. Start the container with:
``` shell
chef-run localhost nginx/recipes/default.rb --user vagrant --password vagrant
```