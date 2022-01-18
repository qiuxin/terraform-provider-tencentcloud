//Print the status of the new allocated virtual machine
output "l4_rules_resource_type" {
  value = data.tencentcloud_dayu_l4_rules.name_test.resource_type
  description = "resource type"
}

output "l4_rules_resource_id" {
  value = data.tencentcloud_dayu_l4_rules.name_test.resource_id
  description = "resource_id"
}

output "l4_rules_name" {
  value = data.tencentcloud_dayu_l4_rules.name_test.name
  description = "name"
}

output "l4_rules_id_type" {
  value = data.tencentcloud_dayu_l4_rules.id_test.resource_type
  description = "resource_type"
}

output "l4_rules_id_resource_id" {
  value = data.tencentcloud_dayu_l4_rules.id_test.resource_id
  description = "resource_id"
}

output "l4_rules_id_rule_id" {
  value = data.tencentcloud_dayu_l4_rules.id_test.rule_id
  description = "rule_id"
}