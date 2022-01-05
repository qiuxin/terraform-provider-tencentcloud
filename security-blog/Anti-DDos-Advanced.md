
# Function
This document is used to help people operate Tencent Auti-DDoS Advanced Product via Terraform API.

# Reference
For the official instance API information, pls refer to  [TencentCloudInstanceAPIHomePage](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/instance).

# Architecture
```
Visitor ----> Auti-DDoS IP Advanced(高仿包) ----> VM in Tencent DataCenter
```
The architecture is consists of three parts:
1) Visitor. In this example, That's your laptop/personal computer.
2) Auti-DDoS Advanced： That's the Anti DDos Product.
3) VM. It is the virtual machine which runs the application.

# Process
In order to test the terraform API in Auti-DDoS Advanced product, the steps are itemized below.

## Step 1: Setup an Anti-DDos Advaned Product
Note well: There is no Terraform API to creat and destory the Anti-DDos Advaned Product. So we have to operate in the web.
[TencentCloudAntiDDosAdvanced](https://console.intl.cloud.tencent.com/ddos/antiddos-advanced/package).

## Step 2: Setup an Virtual Machine
Note well: It is recommened to set up the VM in the same avaliable zone with Anti-DDos Advaned Product.
In this example ,we set VM and Anti-DDos Advaned Product both in Singapore.

It is OK to setup VM via terraform API.  Refer to [SetupVMInTecentCloudIntl](https://github.com/qiuxin/terraform-provider-tencentcloud/tree/master/examples/tencentcloud-instance-robert).

## Step 3: Configure Anti-DDoS Advanced
Note well: It is recommened to set up the VM in the same avaliable zone with Anti-DDos Advaned Product.

| NO | Name | Function | Test Result |
| :-----| :----: | :----:| :----:|
| 1 | 单元格  | 单元格  |  单元格  | 
| 2 | 单元格  | 单元格  | 单元格  | 


# API Function Supported
Run the following commands to make it work. Have a try and enjoy it!

Init the terrform core and download the related packets
```
terraform init
```

Show the deploy plan prior to real deployment
```
terraform plan
```

Deploy the code
```
terraform apply
```

Destroy the code
```
terraform destory
```
