# Vagrant Dev Manager 


## Vagrant Manager

You can use vagrant manager on top of this Vagrant File
http://vagrantmanager.com/

## How to

### Install

Install VirtualBox and Vagrant

#### Vagrant Plugin

This vagrantfile rely on plugins, you need to install them

- vagrant-hostmanager
- vagrant-triggers
- vagrant-auto_network


### Create your machine(s)

Create yml files describing any machines you want to create and place them in the /machines folder
See /examples/machine.example.yml for a template.

### Create SSH keys

Create a private/public keys and add them to the machine configuration

```
# SSH
ssh_private: keys/id_rsa
ssh_public: keys/id_rsa.pub
```


## HOSTNAMES

By Default Machine ip-address and hostname are automatically managed and linked by Vagrant

Each guest will have line setup in their /etc/hosts

```
HOST_IP vagrant-host
```

So that if you want to connect to the host from the box you can just use vagrant-host

Each guest machines has access to the other machines via /etc/hosts
 
```
MACHINE-A-IP   machine-a.dev
MACHINE-A-IP   machine-a-alias1.dev
MACHINE-A-IP   machine-a-alias2.dev

MACHINE-B-IP   machine-b.com
MACHINE-B-IP   machine-b-alias.com
```


## Provisionning 

### Ansible

if ansible = true and a correct playbook file is found vagrant will use Ansible local provisioner to provision the machine

By Default Vagrant will look in your source_www folder for file named 

```
ansible-playbook.yml
```

You can specify what playbook file to use with the "ansible_guest_playbook" variable

It also register default roles from the folder /vagrant/provisioners/ansible/roles
Default Roles are 

- Server
- Apache
- Php
- Mysql
- Composer

### Other 

@TODO

## Machine Configuration 



| Name                   | Description                                                                                                                                                 |
|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| name                   | Box name                                                                                                                                                    |
| box                    | What Vagrant Machine to use                                                                                                                                 |
| box_memory             | Memory assigned to the box                                                                                                                                  |
| box_cpus               | Number of Cpus Assigned to the box                                                                                                                          |
| ssh_private            | Path to your private key to use to connect to the box                                                                                                       |
| ssh_public             | Path to your public key to use to connect to the box                                                                                                        |
| hostname               | HOSTNAME of the box                                                                                                                                         |
| aliases                | [Optional] Array of aliases that will point to this box                                                                                                     |
| source_www             | Project Source path                                                                                                                                         |
| sync                   | Other folders to synchronize between host and guest Each folder has 3 parameters, - host: path to host folder - guest: path to guest folder - id: unique-id |
| ansible                | true/false if you want to use ansible to provision the box                                                                                                  |
| ansible\_guest\_playbook | Path to the ansible playbook file - (In the Box - not host) 


## Other Command

Reload Host for all machines and host

```
vagrant hostmanager
```