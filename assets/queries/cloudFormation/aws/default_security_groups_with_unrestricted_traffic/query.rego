package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {						# inline rules
	resource := input.document[i].Resources[security_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	resource.Properties.GroupName == "default"
	check_rules(resource.Properties)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "AWS::EC2::SecurityGroup",
		"resourceName": cf_lib.get_resource_name(resource, security_group_name),
		"searchKey" : sprintf("Resources.%s.Properties", [security_group_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Any 'AWS::EC2::SecurityGroup' with 'Properties.GroupName' set to 'default' should not have any traffic rules set.",
		"keyActualValue": sprintf("'Resources.%s' has 'Properties.GroupName' set to 'default' and traffic rules set in 'Properties'.", [security_group_name]),
		"searchLine" : common_lib.build_search_line(["Resources", security_group_name, "Properties"], [])
	}
}

CxPolicy[result] {						# standalone rules
	resource := input.document[i].Resources[security_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	resource.Properties.GroupName == "default"
	rules := search_for_standalone_rules(security_group_name, input.document[y])
	rule := rules.rule_list[x]

	check_standalone_rule(security_group_name, rule)

	result := {
		"documentId": input.document[y].id,
		"resourceType": "AWS::EC2::SecurityGroup",
		"resourceName": cf_lib.get_resource_name(resource, security_group_name),
		"searchKey" : sprintf("Resources.%s.Properties.GroupId", [rules.names[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Any 'AWS::EC2::SecurityGroup' with 'Properties.GroupName' set to 'default' should not have any traffic rules set.",
		"keyActualValue": sprintf("'Resources.%s' has 'Properties.GroupName' set to 'default' and a standalone '%s' rule set.", [security_group_name, rule.Type]),
		"searchLine" : common_lib.build_search_line(["Resources", rules.names[x], "Properties", "GroupId"], [])
	}
}

search_for_standalone_rules(sec_group_name, doc) = rules_with_names {
  rule_types := ["AWS::EC2::SecurityGroupIngress", "AWS::EC2::SecurityGroupEgress"]
  resources := doc.Resources

  names := [name |
    rule := resources[name]
    rule.Type == rule_types[_]
    cf_lib.get_name(rule.Properties.GroupId) == sec_group_name
  ]

  rules_with_names := {
    "rule_list": [resources[name] | name := names[_]],
    "names": names
  }
}

check_standalone_rule(security_group_name, rule)  {
	cf_lib.get_name(rule.Properties.GroupId) == security_group_name
}

check_rules(properties) {
	inline_rules := ["SecurityGroupIngress","SecurityGroupEgress"]
	count(properties[inline_rules[_]]) != 0
}
