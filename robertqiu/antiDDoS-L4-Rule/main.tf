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

resource "tencentcloud_dayu_l4_rule" "test_rule" {
  resource_type             = "bgpip"
  resource_id               = "bgpip-000004uv"
  name                      = "rule_test"
  protocol                  = "TCP"
  s_port                    = 99
  d_port                    = 77
  source_type               = 2
  health_check_switch       = false
  health_check_timeout      = 30
  health_check_interval     = 35
  health_check_health_num   = 5
  health_check_unhealth_num = 10
  session_switch            = false
  session_time              = 300

  source_list {
    source = "2.2.2.2"
    weight = 100
  }
}