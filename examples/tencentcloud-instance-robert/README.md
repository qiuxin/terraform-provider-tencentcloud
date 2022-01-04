
# Function
This example is used to deploy and destroy an instance via Terraform API in Tencent Cloud. 


# Reference
For the official instance API information, pls refer to  [TencentCloudInstanceAPIHomePage](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/instance).

## New Functions
Comparing to the example in official website [TencentCloudInstanceAPIHomePage](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/instance), I made the following improments:
1. Assign a public IP address for the new Virtual Machine
2. Deploy a Security Group for the new Vitrual Machine
3. Make different types of terraform file(resouce,data,variable and so on) into different tf files.
4. Setup the max out bandwidth for the new virtual machine 
5. Setup the password for the new virtual machine
6. Add the output file, which prints ```private_ip_address```,```public_ip_address```,```create_time```,```expired_time```,```instance_status```

# Quick start
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

# Note well
The following TENCENTCLOUD_SECRET_ID and TENCENTCLOUD_SECRET_KEY in variable.tf has to be configured prior to the test. which is the token required to operate Tencent Cloud. <br>
```
/* This is used to configure the variable */
variable "TENCENTCLOUD_SECRET_ID" {
  description = "This is secret_id."
  type = string
  default = "*************"
}

variable "TENCENTCLOUD_SECRET_KEY" {
  description = "This is secret key."
  type = string
  default = "*************"
}
```