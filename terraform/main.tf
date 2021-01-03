###############################################################################
# Provider section

terraform {
    required_version = ">= 0.13"
    required_providers {
      libvirt = {
        source = "dmacvicar/libvirt"
        version = "0.6.3"
      }
    }
}

provider "libvirt" {
    uri = "qemu:///system"
}

###############################################################################
# Variable section
variable "os_image" {
    type = string
    default = "/var/lib/libvirt/images/rhel-8.3-x86_64-kvm.qcow2"
}

variable "public_key" {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "libvirt_pool" {
    type = string
    default = "default"
}

variable "libvirt_network" {
    type = string
    default = "default"
}

variable "pool" {
    type = string
    default = "default"
}

variable "hostname" {
    type = string
    default = "rhel8-lab"
}

variable "domain" {
    type = string
    default = "example.com"
}

variable "iface" {
    type = string
    default = "eth0"
}

variable "network_config" {
    type = map
    default = {
        hostIP = "192.168.122.10"
        broadcast = "192.168.122.255"
        dns = "192.168.122.1"
        gateway = "192.168.122.1"
        network= "192.168.122.0"
    } 
}

###############################################################################
# Data section
data "template_file" "user_data" {
    template = file("${path.module}/cloud_init.cfg")
    vars = {
      hostname = var.hostname
      public_key = var.public_key
      fqdn = "${var.hostname}.${var.domain}"
      iface = var.iface
    }
}

data "template_file" "meta_data" {
    template = file("${path.module}/network_config.cfg")
    vars = {
      domain = var.domain
      hostIP = var.network_config["hostIP"]
      dns = var.network_config["dns"]
      gateway = var.network_config["gateway"]
      network = var.network_config["network"]
      broadcast = var.network_config["broadcast"]
      iface = var.iface
    }
}

###############################################################################
# Resource section
resource "libvirt_volume" "rhel8-base" {
  pool = var.pool
  name = "rhel8-base"
  source = var.os_image
}

resource "libvirt_cloudinit_disk" "commoninit" {
    name = "rhel8-commoninit.iso"
    pool = var.libvirt_pool
    user_data = data.template_file.user_data.rendered
    meta_data = data.template_file.meta_data.rendered
}

resource "libvirt_domain" "domain-rhel8" {
  name = var.hostname
  memory = "2048"
  vcpu = 2
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.rhel8-base.id
  }

  network_interface {
    network_name = var.libvirt_network
  }

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

}


###############################################################################
# Output section
output "host_address" {
    value = var.network_config["hostIP"]
    description = "Host ip address"
}
