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

resource "tencentcloud_dayu_l7_rule" "test_rule" {
  resource_type             = "bgpip"
  resource_id               = "bgpip-000004uv"
  name                      = "rule_test"
  domain                    = "www.robertqiu.site"
  protocol                  = "http"
  switch                    = true
  source_type               = 2
  source_list               = ["43.156.52.84:80"]
  ssl_id                    = "%s"
  health_check_switch       = false
  health_check_code         = 31
  health_check_interval     = 30
  health_check_method       = "GET"
  health_check_path         = "/"
  health_check_health_num   = 5
  health_check_unhealth_num = 10
}
 