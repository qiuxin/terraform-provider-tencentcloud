terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

provider "tencentcloud" {
  region = var.TENCENTCLOUD_REGION
  secret_id = var.TENCENTCLOUD_SECRET_ID
  secret_key = var.TENCENTCLOUD_SECRET_KEY
}


// Create VPC resource
resource "tencentcloud_vpc" "app" {
  cidr_block = "10.0.0.0/16"
  name       = "awesome_app_vpc"
}

resource "tencentcloud_subnet" "app" {
  vpc_id            = tencentcloud_vpc.app.id
  availability_zone = data.tencentcloud_availability_zones_by_product.my_favorate_zones.zones.0.name
  name              = "awesome_app_subnet"
  cidr_block        = "10.0.1.0/24"
}

// Create 1 CVM instances to host awesome_app
resource "tencentcloud_instance" "my_awesome_app" {
  instance_name     = "awesome_app"
  availability_zone = data.tencentcloud_availability_zones_by_product.my_favorate_zones.zones.0.name
  image_id          = data.tencentcloud_images.my_favorate_image.images.0.image_id
  instance_type     = data.tencentcloud_instance_types.my_favorite_instance_types.instance_types.0.instance_type
  system_disk_type  = "CLOUD_PREMIUM"
  system_disk_size  = 50
  hostname          = "user"
  project_id        = 0
  vpc_id            = tencentcloud_vpc.app.id
  subnet_id         = tencentcloud_subnet.app.id
  count             = 1
  //allocate pubic ip address
  allocate_public_ip = true
  internet_max_bandwidth_out = 1
  //instance password
  password =  "testProject123!"
  //connect to the security group
  security_groups =  [tencentcloud_security_group.foo.id]
 
  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  tags = {
    tagKey = "tagValue"
  }
}

// Config the security group for CVM
resource "tencentcloud_security_group" "foo" {
  name = "tencent-instance-test-security-group"
}

resource "tencentcloud_security_group_lite_rule" "foo" {
  security_group_id = tencentcloud_security_group.foo.id

  ingress = [
    "ACCEPT#192.168.1.0/24#80#TCP",
    "DROP#8.8.8.8#80,90#UDP",
    "ACCEPT#0.0.0.0/0#80-90#TCP",
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]

  egress = [
    "ACCEPT#192.168.0.0/16#ALL#TCP",
    "ACCEPT#10.0.0.0/8#ALL#ICMP",
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]
}