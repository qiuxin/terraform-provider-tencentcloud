# Table of contents

- [Table of contents](#table-of-contents)
- [Information](#information)
- [Function](#function)
- [Topology](#topology)
- [Environment-construction](#environment-construction)
  - [Step1-Install Terraform](#step1-install-terraform)
  - [Step 2 - Create a virtual machine](#step-2---create-a-virtual-machine)
  - [第三步-创建DDoS](#第三步-创建ddos)
  - [第四步 调用L4层接口](#第四步-调用l4层接口)
    - [4.1 配置虚拟机安全组](#41-配置虚拟机安全组)
    - [4.2  通过Terraform API来配置DDOS L4的规则](#42--通过terraform-api来配置ddos-l4的规则)
    - [4.3 测试访问](#43-测试访问)
  - [第五步-调用L7层接口](#第五步-调用l7层接口)
    - [5.1 配置虚拟机安全组](#51-配置虚拟机安全组)
    - [5.2 购买域名](#52-购买域名)
    - [5.3 配置腾讯云的DNS域名解析](#53-配置腾讯云的dns域名解析)
    - [5.4 通过Terraform API来配置DDOS L7规则](#54-通过terraform-api来配置ddos-l7规则)
    - [5.5 测试网站是否可以正常访问](#55-测试网站是否可以正常访问)
- [参考文档](#参考文档)

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

# Environment-construction

## Step1-Install Terraform

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

## Step 2 - Create a virtual machine

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

Run terraform comand, for here, a virtual machine defined in main.tf will be created.
```
terraform apply
```

Run terraform destory command. The resource created by `terraform apply` will be destoried.
```
terraform destory
```

执行terraform命令，打印输出定义的output参数。<br>
```
terraform output
```

虚拟机创建完成之后，在上面安装nginx，并且提供服务。<br>

```
yum install -y nginx
```

启动nginx服务：<br>
```
systemctl nginx enable
```

查看nginx服务状体，确定是否被启动<br>

```
systemctl status nginx
```

成功启动成功之后，就可以在其它机器上，通过“IP”来访问nginx提供的web服务了。<br>

<br>
<br>

## 第三步-创建DDoS

目前腾讯云有关DDoS环境的创建和删除，暂时不支持Terraform方式，所以这部分工作需要使用传统的Web界面进行配置。<br>

<br>
<br>

## 第四步 调用L4层接口

### 4.1 配置虚拟机安全组

数据接入高仿IP之后，数据包的源地址会被做NAT，需要将虚拟机的安全组开通Forwarding IP Range。<br>
有关具体的Forwarding IP Range，可以在国际站的：Anti-DDoS Advanced(New) --> Service Packages 界面下查询到。<br>
<br>
<br>

### 4.2  通过Terraform API来配置DDOS L4的规则

具体创建需要用的接口，以及调用样例，详见：[腾讯云Terraform L4 Rule](https://github.com/qiuxin/terraform-provider-tencentcloud/tree/master/robertqiu/antiDDoS-L4-Rule)<br>
在如上文件夹中，主要有四个文件：<br>

- main.tf: Terraform 的入口文件，需要引用的文件路径，使用云资源的密钥，文件中配置了DDoS L4层的转发规则，包括在指定的`resource_id`DDoS资源上的源端口，转发端口，优先级，健康检查等规则。<br>
- data.tf: 在腾讯云资源中查找到最对应的资源，查找到的资源通过参数的方式输入给main.tf中的资源。<br>
- outputs.tf: 输出的参数，在`terraform apply`运行完成后 或者 运行`terraform output`将会打印这里定义的参数。这里主要打印了：配置L4规则中的一些参数信息<br>。
- variable.tf: 定义了main.tf中需要使用参数，其中包括：虚拟机可用区域`TENCENTCLOUD_REGION`，使用腾讯云需要配置的`TENCENTCLOUD_SECRET_ID`和`TENCENTCLOUD_SECRET_KEY`。<br>
这样分开文件书写的好处是，避免main.tf文件过长，更容易快速找到不同类型的资源和参数。<br>
定义好了如上文件，在对应的文件夹下，直接运行如下命令即可：<br>

```
terraform init
```

确定被调用的文件，计算执行计划。<br>

```
terraform plan
```

执行terraform命令，创建虚拟机。<br>

```
terraform apply
```

执行terraform命令，删除虚拟机。<br>

```
terraform destory
```

执行terraform命令，打印输出定义的output参数。<br>

```
terraform output
```

成功运行`terraform apply`之后，就可以在Anti-DDoS配置界面中看到对应的配置了。<br>
<br>
<br>

### 4.3 测试访问

配置完虚拟机安全组之后，就可以通过高仿IP提供的IP地址来登陆访问虚拟机了。通过 “ssh命令 + 高仿IP” 的组合来访问虚拟机。 <br>

```
ssh root@${高仿IP地址} -p $port
```

<br>
<br>

## 第五步-调用L7层接口

### 5.1 配置虚拟机安全组

数据接入高仿IP之后，数据包的源地址会被做NAT，需要将虚拟机的安全组开通Forwarding IP Range。<br>
有关具体的Forwarding IP Range，可以在国际站的：`Anti-DDoS Advanced(New) --> Service Packages` 界面下查询到。<br>
注：4.1和5.1的操作是一样的，如果在4.1已经操作过，无需重复操作。
<br>
<br>

### 5.2 购买域名

如果没有域名，访问如下网站进行购买：[腾讯云域名购买](https://console.cloud.tencent.com/domain)<br>
![腾讯云域名购买示意图](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/buy-domain.png "腾讯云域名购买示意图")<br>

如果已经有腾讯云域名，直接进入5.3.
如果需要转入，则可以转入域名。
<br>
<br>

### 5.3 配置腾讯云的DNS域名解析

以我的域名，`http://www.robertqiu.site/` 为例， 配置DNS解析如下：
![腾讯云DNS解析](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/domain-setup.png "腾讯云DNS解析")<br>
<br>
<br>

### 5.4 通过Terraform API来配置DDOS L7规则

具体创建需要用的接口，以及调用样例，详见：[腾讯云Terraform L7 Rule](https://github.com/qiuxin/terraform-provider-tencentcloud/tree/master/robertqiu/antiDDoS-L7-Rule)<br>

- main.tf: Terraform 的入口文件，需要引用的文件路径，使用云资源的密钥，文件中配置了DDoS L7层的转发规则。<br>
- data.tf: 在腾讯云资源中查找到最对应的资源，查找到的资源通过参数的方式输入给main.tf中的资源。<br>
- outputs.tf: 输出的参数，在`terraform apply`运行完成后 或者 运行`terraform output`将会打印这里定义的参数。<br>。
- variable.tf: 定义了main.tf中需要使用参数，其中包括：资源可用区域`TENCENTCLOUD_REGION`，使用腾讯云需要配置的`TENCENTCLOUD_SECRET_ID`和`TENCENTCLOUD_SECRET_KEY`。<br>
这样分开文件书写的好处是，避免main.tf文件过长，更容易快速找到不同类型的资源和参数。<br>
定义好了如上文件，在对应的文件夹下，直接运行如下命令即可：<br>

```
terraform init
```

确定被调用的文件，计算执行计划。<br>

```
terraform plan
```

执行terraform命令，创建虚拟机。<br>

```
terraform apply
```

执行terraform命令，删除虚拟机。<br>

```
terraform destory
```

执行terraform命令，打印输出定义的output参数。<br>

```
terraform output
```

成功运行`terraform apply`之后，就可以在Anti-DDoS配置界面中看到对应的配置了。<br>
<br>
<br>

### 5.5 测试网站是否可以正常访问

测试网站，可以被正常访问。
![网站访问](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/website-look.png "网站访问")<br>
<br>
<br>

# 参考文档

[腾讯官网API](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/instance)<br>
