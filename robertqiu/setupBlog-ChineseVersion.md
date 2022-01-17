# 文档说明
该文档用于帮助大家快速使用Terraform平台/接口来操作腾讯云的DDoS产品。<br>
使用Terraform来配置腾讯云的DDoS产品，不仅仅涉及到DDoS产品本身, 还涉及到虚拟机, 网络, 安全组等操作。需要先配置好虚拟机，网络，安全组等信息，然后再和DDoS做关联。<br>


# 总体架构
目标配置的总体架构如下图：<br>
![DDoS Architecture](https://github.com/qiuxin/terraform-provider-tencentcloud/blob/master/robertqiu/picture/DDoS-Architectrure.png "DDoS Architecture")<br>
其中：<br>
- User: 表示需要访问源站的用户，用户的访问请求先发给DDoS产品进行过滤和清洗后，会被送往需要访问的源站。<br>
- Tencent DDos: 为腾讯DDoS产品，可以是高仿IP（DDoS部署位置在云外） 或者 高仿包（DDoS部署位置在云内）。<br>
- VM: 虚拟机为业务的源站，用户的访问目标。<br>
- 配置电脑: 图中的笔记本，用于表示Terraform平台的安装位置。该配置电脑通过Terraform API来配置DDoS产品，虚拟机产品，以及相关的网络和安全组。<br>


# 环境搭建
## 第一步 环境搭建：安装Terraform
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


## 第一步 环境搭建：安装Terraform



## 第一步 环境搭建：安装Terraform
