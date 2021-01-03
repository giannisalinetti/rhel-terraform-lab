# RHEL Terraform Lab

This project is a simple automation using Ansible and Terraform to provision
a RHEL 8 lab for demo and lab purposes.

## Dependencies
- [Terraform](https://www.terraform.io/downloads.html) ~> 0.13
- [Teraform Libvirt Provider](https://github.com/dmacvicar/terraform-provider-libvirt)

A RHEL 8.x boot ISO must be present under `/var/lib/libvirt/images`. The ISO
can be freely downloaded from Red Hat 
[Products Download](https://access.redhat.com/downloads/content/479/) section.

## Vars file for RHN authentication
To automate the subscription process of the RHEL instance, the RHN ID and password
must be provided.
The variable `rhd_ind` and `rhn_password` are stored by default in a file
called `rhn_vars.yaml` which is not present in this repo and deliberately
put in the .gitignore file.
It is up to the user to create this file.

Before provisioning, create the `rhn_vars.yaml` file with the variables, 
populating it with your valid rhn_id and password:
```
---
rhn_id: "foo"
rhn_password: "bar"
```

## Maintainers
- Gianni Salinetti <gsalinet@redhat.com>
