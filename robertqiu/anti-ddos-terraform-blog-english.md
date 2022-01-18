# Table of contents
- [Information](#Information)
- [Terraform功能](#Terraform功能)
- [部署环境拓扑架构](#部署环境拓扑架构)
- [环境搭建](#环境搭建)
  - [第一步 配置电脑安装Terraform](#第一步-配置电脑安装Terraform)
  - [第二步 创建虚拟机](#第二步-创建虚拟机)
  - [第三步 创建DDoS](#第三步-创建DDoS)
  - [第四步 调用L4层接口](#第四步-调用L4层接口)
  - [第五步 调用L7层接口](#第五步-调用L7层接口)
- [参考文档](#参考文档)


# Information
This document helps you quickly use the Terraform platform/interface to operate Tencent Cloud's DDoS products.<br>
In order to operate Tencent DDoS product via Terraform API, the whole architecture/topology(including network, virtual machine, DDoS, Security groups and so on) is required to set up prior to run `terraform command`.<br>

# Terraform功能
Terraform是一个Code as Platform平台，它可以帮助用户实现通过一个平台一种语言（HCL：HashiCorp Configuration Language）来高效配置和操作不同的云资源。<br>
Terraform操作不同的云资源是通过不同公司提供的Provider（中文也叫做：插件。英语也叫做Plugin。Provider是一种特殊的Plugin，或者说Terraform Plugin）来实现的。<br>
不同的公司会提供自己的Provider用于和Terraform平台做对接，详见[Terraform Provider](https://registry.terraform.io/browse/providers)<br>
<br>
因为不同公司的Terraform Provider都是不同的，所以当一个公司切换云服务商的时候，并不能做到所有的代码不改动，在调用Terraform Provider的部分还是要做适配性的改动。<br>
Terraform Provider主要实现的功能和原理是：将Terraform API转换成各个云厂商自己的API，通过各个云厂商自己的API来操作自己的云资源。<br>
对于腾讯云来说，就是将[腾讯云Terraform API](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest)转换成[腾讯云API](https://cloud.tencent.com/document/api)。<br>

有关Terraform功能维度的示意图如下：<br>
![Terraform功能维度示意图](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/provider.png "Terraform功能维度示意图")<br>

# 部署环境拓扑架构
目标配置的总体架构如下图：<br>
![DDoS Architecture](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/DDoS-Architectrure.png "DDoS Architecture")<br>
其中：<br>
- User: 表示需要访问源站的用户，用户的访问请求先发给DDoS产品进行过滤和清洗后，会被送往需要访问的源站。<br>
- Tencent DDos: 为腾讯DDoS产品，可以是高仿IP（DDoS部署位置在云外） 或者 高仿包（DDoS部署位置在云内）。<br>
- VM: 虚拟机为业务的源站，用户的访问目标。<br>
- 配置电脑: 图中的笔记本，用于表示Terraform平台的安装位置。该配置电脑通过Terraform API来配置DDoS产品，虚拟机产品，以及相关的网络和安全组。<br>


# 环境搭建
## 第一步-配置电脑安装Terraform
配置电脑上，需要先安装Terraform。我使用的是CentOS系统，安装命令如下：<br>

```
sudo yum install -y yum-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

sudo yum -y install terraform
```

安装完成之后，使用如下命令测试是否安装成功：<br>
```
[root@VM-32-16-centos ~]# terraform version
Terraform v1.0.11
on linux_amd64
```

有关更多操作系统的安装方法，详见：
[官网安装说明](https://learn.hashicorp.com/tutorials/terraform/install-cli)<br>

<br>
<br>


## 第二步-创建虚拟机

在配置电脑上安装Terraform之后，要做到的就是，利用Terraform在腾讯云上创建虚拟机。<br>
具体创建需要用的接口，以及调用样例，详见：[腾讯云Terraform Instance](https://github.com/qiuxin/terraform-provider-tencentcloud/tree/master/robertqiu/instance)<br>
在如上文件夹中，主要有四个文件：<br>
- main.tf: Terraform 的入口文件，需要引用的文件路径，使用云资源的密钥，文件中创建了需要创建的资源，包括：虚拟机资源，安全组资源，VPC等资源。<br>
- data.tf: 在腾讯云资源中查找到最对应的资源，查找到的资源通过参数的方式输入给main.tf中的资源。<br>
- outputs.tf: 输出的参数，在`terraform apply`运行完成后 或者 运行`terraform output`将会打印这里定义的参数。主要包括：虚拟机的公网IP，私网IP，创建时间等。<br>
- variable.tf: 定义了main.tf中需要使用参数，其中包括：虚拟机可用区域，使用腾讯云需要配置的`TENCENTCLOUD_SECRET_ID`和`TENCENTCLOUD_SECRET_KEY`。<br>
这样分开文件书写的好处是，避免main.tf文件过长，更容易快速找到不同类型的资源和参数。<br>
如果需要使用如上虚拟机的Terraform接口，配置自己的`TENCENTCLOUD_SECRET_ID`和`TENCENTCLOUD_SECRET_KEY`之后，运行如下命令即可：<br>

初始化<br>
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