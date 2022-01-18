/* This is used to configure the variable */
variable "TENCENTCLOUD_REGION" {
  description = "This is region."
  type = string
  default = "ap-singapore"
}

variable "TENCENTCLOUD_SECRET_ID" {
  description = "This is secret_id."
  type = string
  /* Set your Tencent Secret ID here prior to run the terraform command */
  default = "*************"
}

variable "TENCENTCLOUD_SECRET_KEY" {
  description = "This is secret key."
  type = string
  /* Set your Tencent Cloud Secret Key here prior to run the terraform command */
  default = "*************"
}