data "tencentcloud_images" "my_favorate_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos"
}

data "tencentcloud_availability_zones_by_product" "my_favorate_zones" {
  product = "cvm"
}

data "tencentcloud_instance_types" "my_favorite_instance_types" {
  filter {
    name   = "instance-family"
    values = ["S3"]
  }

  cpu_core_count = 1
  memory_size    = 1
}
