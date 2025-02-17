<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Information](#information)
- [Function](#function)
- [Topology](#topology)
- [Environment construction](#environment-construction)
  - [Step1 Install Terraform](#step1-install-terraform)
  - [Step 2 Create a virtual machine](#step-2-create-a-virtual-machine)
  - [Step3 Create DDoS](#step3-create-ddos)
  - [Step4 Config L4 Rule](#step4-config-l4-rule)
    - [4.1 Config Security Group of VM(Origin Server)](#41-config-security-group-of-vmorigin-server)
    - [4.2  Config L4 Rule via Terraform API](#42--config-l4-rule-via-terraform-api)
    - [4.3 Test](#43-test)
  - [Step5 Config L7 Rule](#step5-config-l7-rule)
    - [5.1 Config Security Group of VM(Origin Server)](#51-config-security-group-of-vmorigin-server)
    - [5.2 Purchase a domain name](#52-purchase-a-domain-name)
    - [5.3 Configuring Tencent Cloud DNS Domain Name Resolution](#53-configuring-tencent-cloud-dns-domain-name-resolution)
    - [5.4 Config L7 Rule via Terraform API](#54-config-l7-rule-via-terraform-api)
    - [5.5 Test](#55-test)
- [Reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Information

This document helps you quickly use the Terraform platform/interface to operate Tencent Cloud's DDoS products.<br>
In order to operate Tencent DDoS product via Terraform API, the whole architecture/topology(including network, virtual machine, DDoS, Security groups and so on) is required to set up prior to run `terraform command`.<br>

# Function

Terraform is a Code as Platform platform that helps users efficiently configure and operate different cloud resources through a platform language (HCL: HashiCorp Configuration Language).<br>

Terraform operates different cloud resources through Providers(aka plugin) provided by different companies.<br>

The providers provided by different compnaies, refer to [Terraform Provider](https://registry.terraform.io/browse/providers)<br>
<br>
Because the Terraform Providers of different companies are different, when a company switches cloud service providers, it is not possible to keep all the code unchanged. The part of calling Terraform Provider still needs to be adapted.<br>

The main functions and principles implemented by Terraform Provider are: convert the Terraform API into the API of each cloud vendor, and operate its own cloud resources through the API of each cloud vendor.<br>

For Tencent Cloud, it is to convert [Tencent Cloud Terraform API](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest) into
 [Tencent Cloud API](https://cloud.tencent.com/document/api). <br>

A schematic diagram of the Terraform functional dimension is as follows：<br>
![Terraform functional dimension diagram](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/provider.png "Terraform functional dimension diagram")<br>

# Topology

The overall structure of the target configuration is as follows:<br>
![DDoS Architecture](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/DDoS-Architectrure.png "DDoS Architecture")<br>
wherein：<br>

- User: Indicates the user who needs to access the origin site. The user's access request is first sent to the DDoS product for filtering and cleaning, and then sent to the origin site. <br>
- Tencent DDos: It is a Tencent DDoS product, which can be deployed inside/outside Tencent cloud. <br>
- VM: The virtual machine is the source site of the business and the user's access destination.<br>
- Computer/Laptop: The computer/laptop in the picture is used to represent the installation location of the Terraform platform. The computer/laptop uses the Terraform API to configure DDoS products, virtual machine products, and related networking and security groups. <br>

# Environment construction

## Step1 Install Terraform

Install Terraform software on the computer. Installation commands for CentOS are itemized below:<br>

```
sudo yum install -y yum-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

sudo yum -y install terraform
```

Test after install successfully.<br>

```
[root@VM-32-16-centos ~]# terraform version
Terraform v1.0.11
on linux_amd64
```

<br>
In terms of installaiton on multiple operation system, please refer to:
[Installation](https://learn.hashicorp.com/tutorials/terraform/install-cli)<br>
<br>
<br>

## Step 2 Create a virtual machine

The second step is creating a virtual machine on Tencent Cloud via terrform API.<br>

The detail codes for creating a VM ,pls refer to [Create Terraform Instance](https://github.com/qiuxin/terraform-provider-tencentcloud/tree/master/robertqiu/instance)
The folder mainly consists of four files:

- main.tf: This is the entry file of Terrform , which includes file path, resources as well as tencent authdication key.
- data.tf: The `data` that is used to search the resource based on given parameters.
- outputs.tf: Define the output parameters, which will be printed during `terraform apply` or `terraform output`.<br>
- variable.tf: Define the parameters which are used in main.tf,including `TENCENTCLOUD_REGION`,`TENCENTCLOUD_SECRET_ID` as well as `TENCENTCLOUD_SECRET_KEY`.

The user who wants to test terraform code should replace `TENCENTCLOUD_SECRET_ID` and `TENCENTCLOUD_SECRET_KEY` before run `terraform command`.  Run the following `terraform command` after replacing `TENCENTCLOUD_SECRET_ID` and `TENCENTCLOUD_SECRET_KEY`:

Initialization<br>

```
terraform init
```

Bonding related terraform and figure out the execute plan. 
```
terraform plan
```

Run `terraform apply` command, for here, a virtual machine defined in main.tf will be created.
```
terraform apply
```

Run `terraform destory` command. The resource created by `terraform apply` will be destoried.
```
terraform destory
```

Print the output parameters defined in `output.tf`。<br>
```
terraform output
```

Install nginx after the virtual machine is created. Ngnix is used to provide web service.<br>
```
yum install -y nginx
```

Start nginx service<br>
```
systemctl nginx enable
```

Check nginx service status<br>
```
systemctl status nginx
```

You can visit the web provided by nginx if the foreing operation is executed successfully. <br>

![Ngnix Web](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/website-look.png "Ngnix Web")
<br>
<br>

## Step3 Create DDoS

Creating and deleting Tencent Anti-DDoS product are NOT supported yet.So creating DDoS product should be operated via website. <br>
<br>
<br>

## Step4 Config L4 Rule

### 4.1 Config Security Group of VM(Origin Server)

After the data is connected to the Anti-DDoS Advanced(New), the source address of the data packet will be changed(Network Address Translation). It is necessary to enable the Forwarding IP Range in the security group of the virtual machine.<br>
Forwarding IP Range, it can be got from tencent office website path  `Anti-DDoS Advanced(New) --> Service Packages `.<br>
<br>
<br>

### 4.2  Config L4 Rule via Terraform API

In terms of the detail Terraform code and API, please refer to [Tencent Terraform L4 Rule Config](https://github.com/qiuxin/terraform-provider-tencentcloud/tree/master/robertqiu/antiDDoS-L4-Rule)<br>

In the above folder, there are mainly four files: <br>

- main.tf: This is the entry file of Terrform , which includes file path, resources, tencent authdication key as well as the configued rules(the source port on the specified `resource_id` DDoS resource, the forwarding port, the priority, Rules such as health checks and so on).
- data.tf: The `data` that is used to search the resource based on given parameters.<br>
- outputs.tf: Define the output parameters, which will be printed during `terraform apply` or `terraform output`.  Some configure parameters are printed here.<br>
- variable.tf: Define the parameters which are used in main.tf,including `TENCENTCLOUD_REGION`,`TENCENTCLOUD_SECRET_ID` as well as `TENCENTCLOUD_SECRET_KEY`.<br>

The advantage of writing separate files in this way is to avoid the main.tf file being too long, and it is easier to quickly find different types of resources and parameters. <br>


The user who wants to test terraform code should replace `TENCENTCLOUD_SECRET_ID` and `TENCENTCLOUD_SECRET_KEY` before run `terraform command`.  Run the following `terraform command` after replacing `TENCENTCLOUD_SECRET_ID` and `TENCENTCLOUD_SECRET_KEY`:<br>

Initialization<br>
```
terraform init
```

Bonding related terraform and figure out the execute plan. <br>
```
terraform plan
```

Run `terraform apply` command, for here, a L4 rule is configured in the product. <br>
```
terraform apply
```


Run `terraform destory` command. The resource created by `terraform apply` will be destoried.<br>
```
terraform destory
```

Print the output parameters defined in `output.tf`。<br>
```
terraform output
```

After successfully running `terraform apply`, corresponding configuration will be shown in the Anti-DDoS website.
<br>
<br>

### 4.3 Test
You can log in and access the virtual machine through IP address provided by Anti DDoS product. Access the virtual machine through the combination of "ssh command + Anti DDoS IP".
```
ssh root@${Anti DDoS IP} -p ${port}
```

<br>
<br>

## Step5 Config L7 Rule

### 5.1 Config Security Group of VM(Origin Server)
After the data is connected to the Anti-DDoS Advanced(New), the source address of the data packet will be changed(Network Address Translation). It is necessary to enable the Forwarding IP Range in the security group of the virtual machine.<br>
Forwarding IP Range, it can be got from tencent office website path  `Anti-DDoS Advanced(New) --> Service Packages `.<br>
<br>
Note well: `Section 4.1` and `Section 5.1` are completely the same. Skip `Section 5.1` if you have operated it in `Section 4.1`.
<br>
<br>

### 5.2 Purchase a domain name
Note well: Skip `5.2 Purchase a domain name` if you have already got a domain name.
If you don't have a domain name, visit the following website to purchase: [Purchase Tencent Cloud Domain Name](https://console.cloud.tencent.com/domain)<br>
![Purchase Tencent Cloud Domain Name Picture](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/buy-domain.png "Purchase Tencent Cloud Domain Name Picture")<br>
<br>
<br>

### 5.3 Configuring Tencent Cloud DNS Domain Name Resolution

Take my domain name `http://www.robertqiu.site/` as an example, configure DNS resolution as follows:
![Tencent Cloud DNS Domain Name Resolution](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/domain-setup.png "Tencent Cloud DNS Domain Name Resolution")<br>
<br>
<br>

### 5.4 Config L7 Rule via Terraform API

In terms of the detail Terraform code and API, please refer to [Tencent Terraform L7 Rule Config](https://github.com/qiuxin/terraform-provider-tencentcloud/tree/master/robertqiu/antiDDoS-L7-Rule)<br>

- main.tf: This is the entry file of Terrform , which includes file path, resources, tencent authdication key as well as the configued rules。<br>
- data.tf: The `data` that is used to search the resource based on given parameters.<br>
- outputs.tf: Define the output parameters, which will be printed during `terraform apply` or `terraform output`.  Some configure parameters are printed here.<br>
- variable.tf: Define the parameters which are used in main.tf,including `TENCENTCLOUD_REGION`,`TENCENTCLOUD_SECRET_ID` as well as `TENCENTCLOUD_SECRET_KEY`.<br>

The advantage of writing separate files in this way is to avoid the main.tf file being too long, and it is easier to quickly find different types of resources and parameters. <br>

The user who wants to test terraform code should replace `TENCENTCLOUD_SECRET_ID` and `TENCENTCLOUD_SECRET_KEY` before run `terraform command`.  Run the following `terraform command` after replacing `TENCENTCLOUD_SECRET_ID` and `TENCENTCLOUD_SECRET_KEY`:<br>
Initialization<br>
```
terraform init
```

Bonding related terraform and figure out the execute plan. <br>
```
terraform plan
```

Run `terraform apply` command, for here, a L7 rule is configured in the product. <br>
```
terraform apply
```

Run `terraform destory` command. The resource created by `terraform apply` will be destoried.<br>
```
terraform destory
```

Print the output parameters defined in `output.tf`。<br>
```
terraform output
```

After successfully running `terraform apply`, corresponding configuration will be shown in the Anti-DDoS website.<br>
<br>
<br>

### 5.5 Test
Test whether the website can be accessed.
![Web Access Picture](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/website-look.png "Web Access Picture")<br>
<br>
<br>

# Reference
[Tencent Offical API](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/instance)
