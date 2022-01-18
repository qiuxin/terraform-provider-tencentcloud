data "tencentcloud_dayu_l7_rules" "domain_test" {
  resource_id   = tencentcloud_dayu_l7_rule.test_rule.resource_id
  resource_type = tencentcloud_dayu_l7_rule.test_rule.resource_type
  domain        = tencentcloud_dayu_l7_rule.test_rule.domain
}