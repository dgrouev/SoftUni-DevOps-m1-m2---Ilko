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

## Workstation installation
1. Use version chef-workstation-21.10.640-1.el8.x86_64.rpm to avoid issue with versions and start another session to workstation machine and install Chef-Workstation and Git by executing the following commands:
``` shell
wget -P /tmp wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/el/8/chef-workstation-21.10.640-1.el8.x86_64.rpm
sudo rpm -Uvh /tmp/chef-workstation-21.10.640-1.el8.x86_64.rpm
sudo dnf install -y git
```

NOTE: Start executing the commands from here

2. Configure Git Client With:
``` shell
git config --global user.email "ilkothetiger@gmail.com"
git config --global user.name "Ilia Dimchev"
```

3. Configure the Ruby provided by Chef:
``` shell
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
echo 'export PATH="/opt/chef-workstation/embedded/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
```

4. Create cookbooks folder and enter it to create test coobook with:
``` shell
mkdir cookbooks && cd cookbooks
chef generate cookbook test
```

5. Edit the default recipe with **vi test/recipes/default.rb** should have the following contents:
``` ruby
docker_service 'default' do
  action [:create, :start]
end


# Pull latest image
docker_image 'nginx' do
  tag 'latest'
  action :pull
end


# Run container exposing ports
docker_container 'my_nginx' do
  repo 'nginx'
  tag 'latest'
  port '80:80'
end
```

6. Create **solo.rb** file with the following contents:
``` shell
file_cache_path "/home/vagrant/cache"
cookbook_path "/home/vagrant/cookbooks"
```

7. Create **solo.json** file with the following contents:
``` json
{
 "run_list": [ "recipe[test]" ]
}
```

8. Download **Docker Cookbook** and unpack it with:
``` shell
knife supermarket download docker
tar xzvf docker-10.4.8.tar.gz
```

9. Add Docker Cookbook as dependency in **metadata.rb** by adding the following line:
``` ruby
depends 'docker', '~> 10.4.8'
```

10. Execute the recipe with:
``` shell
sudo chef-solo -c solo.rb -j solo.json
```

11. If the recipe fails due to permission denied, try the following and repeat step 12:
``` shell
sudo systemctl enable --now docker
```