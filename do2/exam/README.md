## Manual steps, should there be any issues with the automation

1. After vagrant up starn an SSH session to the Containers machine and execute these commands:
``` shell
cd /vagrant/tfm-1-kafka
terraform init
terraform apply --auto-approve
```

2. Then switch to directory **/vagrant/tfm-2-exporter** and execute the following commands:
``` shell
cd /vagrant/tfm-2-exporter/
terraform init
terraform apply --auto-approve
```

3. One more time switch to directory **/vagrant/tfm-3-app** and execute the following commands:
``` shell
cd /vagrant/tfm-3-app/
terraform init
terraform apply --auto-approve
```

4. And for the last time switch to directory **/vagrant/tfm-4-mon** and execute the following commands:
``` shell
cd /vagrant/tfm-4-mon/
terraform init
terraform apply --auto-approve
```

5. Executing the commands from the previous steps should spin-up all the needed applications as containers.

6. The solution should be deployed just by executing vagrant up, if not do the next step

7. Comment line #49 should there be any issues, e.g, screen freezing while terraform is running the containers and execute the commands above manually