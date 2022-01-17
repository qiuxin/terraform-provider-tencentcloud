//Print the private ip address of the new allocated virtual machine
output "private_ip_address" {
  value = tencentcloud_instance.my_awesome_app[0].private_ip
  description = "The private IP address of the new virtual machine"
}

//Print the public ip address of the new allocated virtual machine
output "public_ip_address" {
  value = tencentcloud_instance.my_awesome_app[0].public_ip
  description = "The public IP address of the new virtual machine"
}

//Print creat time of the new allocated virtual machine
output "vm_create_time" {
  value = [tencentcloud_instance.my_awesome_app[0].create_time]
  description = "The create time of the new virtual machine"
}

//Print expired time of the new allocated virtual machine
output "vm_expired_time" {
  value = [tencentcloud_instance.my_awesome_app[0].expired_time]
  description = "The expired time of the new virtual machine"
}

//Print the status of the new allocated virtual machine
output "vm_instance_status" {
  value = [tencentcloud_instance.my_awesome_app[0].instance_status]
  description = "The status of the new virtual machine"
}