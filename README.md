# aws-nat-bastion-bosh-cf

Setup the prerequisites, clone this repo, run the commands, and you'll have a fully functional Cloud Foundry to deploy applications on AWS.

How does it work? [Terraform](https://www.terraform.io/) configures the networking infrastructure on AWS, next `bosh-init` sets up the BOSH Director, then BOSH installs Cloud Foundry.

## Goals

  * Re-sizable - Start small, but can grow as big as you need.  See `config/aws/cf-<size>.yml` for examples.
  * Accessible - Give users the ability to try Cloud Foundry on AWS as quickly and easily as possible.
  * Configurable - Manage the deploy manifests with [Spruce](https://github.com/geofffranks/spruce).

## Prerequisites

Examples use a Mac OS X operating system.  Ensure the following are setup before continuing.

  * [Amazon Web Services Setup](docs/aws-setup.md)
  * Mac OS X with [Homebrew](http://brew.sh/)

## Installation

### Clone Repo

In your local code folder clone the repo, then change to that folder.

```sh
git clone https://github.com/cloudfoundry-community/aws-nat-bastion-bosh-cf.git
```

### Prepare

The `make prepare` command will install Terraform to your `/usr/local/bin` folder.

```sh
make prepare
```

### SSH Key

Both BOSH and Cloud Foundry expect to find the key named `sshkeys/bosh.pem`.  Rename your public key to match this and copy it to the `sshkeys` folder.

### Configure Terraform

Terraform creates a `plan`.  Then users `apply` the `plan` and the infrastructure is allocated for the given provider.

Configure the `terraform/aws/terraform.tfvars` file and Terraform will know who you are on AWS and where to create it's resources.

Copy the example file to the `terraform.tfvars` file:

```sh
cp terraform/aws/terraform.tfvars.example terraform/aws/terraform.tfvars
```

Follow the instructions in the example file about any changes that need to be made.

### Create Virtual Private Cloud

Using Terraform now we'll create the AWS Virtual Private Cloud and ancillary gateways, routes and subnets.  For more read about the [network topology](docs/network-topology.md).

```sh
make plan
make apply
```

When an apply is complete the output will look something like this:

```
Apply complete! Resources: 27 added, 0 changed, 0 destroyed.
```

### Provision Bastion Host

A bastion host is a server that sits on a public Internet address and provides a special service.  This server is a jump-box that bridges the connection between public and private subnets.

```sh
make provision-base
```

### Create BOSH Director

Using `bosh-init` we'll be creating the BOSH Director instance next.

```sh
make provision-bosh
```
### Install CF CLI

Installing the Cloud Foundry CLI tool on the Bastion Host can be performed by running this command.

```sh
make provision-cf-cli
```

### Deploy Cloud Foundry

Once the base bastion server and BOSH Director are setup Cloud Foundry can be deployed.

```sh
make provision-cf
```

### Make All

Running `make all`, will run the above commands in order:

```
  make plan
  make apply
  make provision-base
  make provision-bosh
  make provision-cf-cli
  make provision-cf
```

## Additional Commands

### Connect to Bastion Server

Connecting to the Bastion host to control the BOSH Director run BOSH cli or Cloud Foundry cli commands run:

```sh
make ssh
```

When running longer running tasks like `make provision-cf` or `make provision-bosh` it can be useful to see progress by running `tail -f /home/centos/provision.log` on the bastion server.  

### Destroy Environment

To tear down the BOSH Director, Bastion server , NAT server and remove the Amazon Virtual Private Cloud definitions defined by Terraform you can run `make destroy`.

```sh
make destroy
```

### Clean Terraform Cache

To reset the Terraform cached files and start over, you can also run:

```sh
make clean
```
Check out [terraform debugging](docs/terraform.md#debugging) for more about troubleshooting Terraform errors.

## Related Repositories

  * [bosh-init](https://github.com/cloudfoundry/bosh-init)
  * [spruce](https://github.com/geofffranks/spruce)
  * [terraform-aws-cf-install](https://github.com/cloudfoundry-community/terraform-aws-cf-install)
  * [terraform-aws-vpc](https://github.com/cloudfoundry-community/terraform-aws-vpc)
  * [terraform-aws-cf-net](https://github.com/cloudfoundry-community/terraform-aws-cf-net)
