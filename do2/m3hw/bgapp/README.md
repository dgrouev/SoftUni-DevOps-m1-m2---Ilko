# Deployment of BGApp with Salt

1. Download the boostrap script:
``` shell
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
```

2. Install Salt Master with:
``` shell
sudo sh bootstrap-salt.sh -M -N -X stable 3006.0
```