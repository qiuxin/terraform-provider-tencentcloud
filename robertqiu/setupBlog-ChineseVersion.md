# 文档说明
该文档用于帮助大家快速使用Terraform平台/接口来操作腾讯云的DDoS产品。<br>
使用Terraform来配置腾讯云的DDoS产品，不仅仅涉及到DDoS产品本身, 还涉及到虚拟机, 网络, 安全组等操作。需要先配置好虚拟机，网络，安全组等信息，然后再和DDoS做关联。<br>

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

# 总体架构
目标配置的总体架构如下图：<br>
![DDoS Architecture](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/DDoS-Architectrure.png "DDoS Architecture")<br>
其中：<br>
- User: 表示需要访问源站的用户，用户的访问请求先发给DDoS产品进行过滤和清洗后，会被送往需要访问的源站。<br>
- Tencent DDos: 为腾讯DDoS产品，可以是高仿IP（DDoS部署位置在云外） 或者 高仿包（DDoS部署位置在云内）。<br>
- VM: 虚拟机为业务的源站，用户的访问目标。<br>
- 配置电脑: 图中的笔记本，用于表示Terraform平台的安装位置。该配置电脑通过Terraform API来配置DDoS产品，虚拟机产品，以及相关的网络和安全组。<br>


# 环境搭建
## 第一步 环境搭建：配置电脑安装Terraform
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


## 第二步 创建虚拟机

在配置电脑上安装Terraform之后，要做到的就是，利用Terraform在腾讯云上创建虚拟机。<br>
具体创建需要用的接口，以及调用样例，详见：[腾讯云Terraform Instance](https://github.com/qiuxin/terraform-provider-tencentcloud/tree/master/robertqiu/instance)<br>
在如上文件夹中，主要有四个文件：<br>
- main.tf: Terraform 的入口文件，需要引用的文件路径，使用云资源的密钥，文件中创建了需要创建的资源，包括：虚拟机资源，安全组资源，VPC等资源。<br>
- data.tf: 在腾讯云资源中查找到最对应的资源，查找到的资源通过参数的方式输入给main.tf中的资源。<br>
- outputs.tf: 输出的参数，在`terraform apply`运行完成后 或者 运行`terraform output`将会打印这里定义的参数。主要包括：虚拟机的公网IP，私网IP，创建时间等。<br>
- variable.tf: 定义了main.tf中需要使用参数，其中包括：虚拟机可用区域，使用腾讯云需要配置的`TENCENTCLOUD_SECRET_ID`和`TENCENTCLOUD_SECRET_KEY`。<br>

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




## 第三步 创建DDoS环境
在配置电脑上安装Terraform之后，要做到的就是，利用Terraform在腾讯云上创建虚拟机。<br>
```

```


## 第四步 连接DDoS和虚拟机


## 第四步 


## 参考文档
[腾讯官网API]（https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/instance） <br>


