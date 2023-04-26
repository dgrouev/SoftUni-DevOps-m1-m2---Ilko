# Creating NGINX container with Chef

1. Create an empty cookbook and enter it:
``` shell
chef generate cookbook nginx
cd nginx
```

2. Add the **"**apt**"** and **"**docker**"** cookbooks as dependencies in metadata.rb:
``` ruby
depends 'apt'
depends 'docker'
```

3. Use the "docker_service" resource to create a docker service in **recipes/default.rb**:
``` ruby
include_recipe 'apt'

docker_service 'default' do
  action [:create, :start]
end
```
