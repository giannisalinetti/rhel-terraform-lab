# RHEL Terraform Lab

This project is a simple automation using Ansible and Terraform to provision
a RHEL 8 lab for demo and lab purposes.

## Dependencies
- [Terraform](https://www.terraform.io/downloads.html) ~> 0.13
- [Teraform Libvirt Provider](https://github.com/dmacvicar/terraform-provider-libvirt)

A RHEL 8.x boot ISO must be present under `/var/lib/libvirt/images`. The ISO
can be freely downloaded from Red Hat 
[Products Download](https://access.redhat.com/downloads/content/479/) section.

## Maintainers
- Gianni Salinetti <gsalinet@redhat.com>
