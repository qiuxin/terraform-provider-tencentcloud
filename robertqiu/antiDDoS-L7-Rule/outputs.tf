output "l7_rules_resource_type" {
  value = data.tencentcloud_dayu_l7_rules.domain_test.resource_type
  description = "resource type"
}

output "l7_rules_resource_id" {
  value = data.tencentcloud_dayu_l7_rules.domain_test.resource_id
  description = "resource_id"
}

output "l7_rules_name" {
  value = data.tencentcloud_dayu_l7_rules.domain_test.domain
  description = "domain"
}
