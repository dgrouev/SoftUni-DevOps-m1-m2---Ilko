terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  # for remote KVM
  # uri = "qemu+ssh://<username>@<kvm-host>/system"
  # for local KVM this is enough
  uri = "qemu:///system"
}

# a base/master image to be used for both machines
resource "libvirt_volume" "centos-stream" {
  name = "centos-stream.qcow2"
  pool = "default"
  source = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20220125.1.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "centos-db" {
  name = "centos-db.qcow2"
  pool = "default"
  base_volume_id = libvirt_volume.centos-stream.id
}

resource "libvirt_volume" "centos-web" {
  name = "centos-web.qcow2"
  pool = "default"
  base_volume_id = libvirt_volume.centos-stream.id
}

data "template_file" "user-data" {
  template = "${file("${path.module}/cloud_init.cfg")}"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit.iso"
  pool = "default"
  user_data      = "${data.template_file.user-data.rendered}"
}

resource "libvirt_domain" "centos-db" {
  name   = "centos-db"
  memory = "2048"
  vcpu   = 1

  # using the default (NAT) network
  network_interface {
    network_name = "default"
    hostname = "db"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.centos-db.id}"
  }

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

  provisioner "file" {
    source      = "./provision-db.sh"
    destination = "/tmp/provision-db.sh"
    connection {
      type        = "ssh"
      user        = "user"
      password    = "UserParolka"
      host        = libvirt_domain.centos-db.network_interface[0].addresses[0]
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision-db.sh",
      "/tmp/provision-db.sh"
    ]
    connection {
      type        = "ssh"
      user        = "user"
      password    = "UserParolka"
      host        = libvirt_domain.centos-db.network_interface[0].addresses[0]
    }
  }
}

resource "libvirt_domain" "centos-web" {
  name   = "centos-web"
  memory = "2048"
  vcpu   = 1
  
  # using the default (NAT) network
  network_interface {
    network_name = "default"
    hostname = "web"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.centos-web.id}"
  }

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

  provisioner "file" {
    source      = "./provision-web.sh"
    destination = "/tmp/provision-web.sh"
    connection {
      type        = "ssh"
      user        = "user"
      password    = "UserParolka"
      host        = libvirt_domain.centos-web.network_interface[0].addresses[0]
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision-web.sh",
      "/tmp/provision-web.sh"
    ]
    connection {
      type        = "ssh"
      user        = "user"
      password    = "UserParolka"
      host        = libvirt_domain.centos-web.network_interface[0].addresses[0]
    }
  }
}

output "ip-db" {
  value = "${libvirt_domain.centos-db.network_interface[0].addresses[0]}"
}

output "ip-web" {
  value = "${libvirt_domain.centos-web.network_interface[0].addresses[0]}"
}