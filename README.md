# Reference Implementation

This repository contains a reference implementation of our Oracle and WebLogic modules. In here we show you how to use best our modules. 

## Disclaimer
We call this a reference implementation, because of the way Puppet is used to build a set of systems using Oracle and Weblogic. The sizes and other values and measures are chosen to get it working in a VirtualBox environment. They are **not chosen** for you to use in your development, test or production environment. **ALWAYS** check with a specialist what settings to use in your environments. 

## Continuous evolving
Although this repository is called a reference implementation, it is by no means the only way to do stuff. In general, there are many more methods you can use. We have chosen some methods we think are working best in large enterprise setups. But because we learn every day, this repository will change in time. Wat was the best today might be superseded by something better tomorrow.

## Starting a node
We use [Vagrant](https://www.vagrantup.com/) to demonstrate this setup. Check [the vagrant site](https://www.vagrantup.com/) on how to setup vagrant software on your laptop.


### Running in Puppet Enterprise

- `pe-master` - A Puppet Enterprise Master node
- `pe-oradb`  - A node containing an Oracle database
- `pe-wls1`   - A node containing a bare Oracle WebLogic installation.
- `pe-wls2`   - A node containing a bare Oracle WebLogic installation, merging into a cluster with node pe-wls1.
- `pe-soa1`   - A node containing an Oracle WebLogic installation containing a SOA cluster
- `pe-soa2`   - A node containing an Oracle WebLogic installation containing a SOA cluster, merging into a cluster with pe-wls2

Before you can start any of the functional nodes (db, soa or wls), you'll have to start the Puppet Enterprise Master:

```
$ vagrant up pe-master
```

You can log in on the master by add the master to your locat hosts file:
```
10.10.10.10 master.example.com master
```

And then pointing your browser to http://master.example.com/. You can use username `admin` and password `welcome1`

You can start the provisioning of a node by using:

```
$ vagrant up pe-oradb
```

Or any other node you want to start. Bare in mind that for running the `soa` nodes, you'll first need to install the database node. The soa nodes use the database node to store the RCU.

### Running masterless

The masterless nodes are useful for experimenting and testing. They allow you to very quickly apply changes to your hiera data and Puppet code and see what is happening. We have supplied you with the following masterless node definitions.

- `ml-oradb`  - A node containing an Oracle database
- `ml-wls1`   - A node containing a bare Oracle WebLogic installation.
- `ml-wls2`   - A node containing a bare Oracle WebLogic installation, merging into a cluster with node ml-wls1.
- `ml-soa1`   - A node containing an Oracle WebLogic installation containing a SOA cluster
- `ml-soa2`   - A node containing an Oracle WebLogic installation containing a SOA cluster, merging into a cluster with ml-wls2


You can start the provisioning of a node by using:

```
$ vagrant up ml-oradb
```

Or any other node you want to start. Bare in mind that for running the `soa` nodes, you'll first need to install the database node. The soa nodes use the database node to store the RCU.


## The software

This repository **doesn't** contain the Oracle or Puppetlabs software needed to get the nodes running. You'll need to get these yourself and put them in the ` software` directory` . Here is a list of the files you need:

- `UnlimitedJCEPolicyJDK7.zip`
- `V44420-01_fmw_12.1.3.0.0_soa.zip`
- `fmw_12.1.3.0.0_infrastructure.jar`
- `fmw_12.1.3.0.0_wls.jar`
- `jdk-7u55-linux-x64.tar.gz`
- `jdk-7u79-linux-x64.tar.gz`
- `p13390677_112040_Linux-x86-64_1of7.zip`
- `p13390677_112040_Linux-x86-64_2of7.zip`
- `p13390677_112040_Linux-x86-64_3of7.zip`
- `puppet-enterprise-2015.2.2-el-6-x86_64.tar.gz`

## Philosophy

To structure this setup we have used the following guidelines:

- Use roles and profiles
- Put version numbers in  `hiera`
- For defining resources, prefer Puppet over `hiera`

### Roles and Profiles
We use the roles and profiles pattern. When using this pattern, every node is assigned one role. This role defines the task the node has to do. A role is then build up by small profile. A profile is a small block of functionality.  You can look at profiles like Lego bricks. With the available Lego bricks(profiles), you can build a house(a role).

### version numbers in  `hiera`
Version numbers are volatile. We want it to be easy to use a newer (or older) version of a specific software component. The best way to support this, is by putting version numbers as variables in `hiera`

### Resources, prefer Puppet over `hiera`
Puppet allows us to read a set of resources from a `hiera`  file and use the `create_resource` function to create them. This can be very handy sometimes. We prefer using resources in Puppet, though. Our reasoning  for this is:

- Use Puppet manifests to define the static part of your infrastructure. Use `hiera` to define the variable stuff. So only if the resources are a variable part of your infrastructure, use resources in ` hiera`
- When a resource created by `create_resource`  fails, you get some pretty weird error messages. It is really hard to track down what resource failed.
- Puppet code allows you to iterate over  arrays and hashes. Most of the times this results in more consise code then when you put the resource in `hiera`.
- When you are using `YAML`  as a `hiera`  backend, it is hard to use references to other ` hiera` settings. Your `YAML`  files et littered with lookup functions and becomes hard to read. 
