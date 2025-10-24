package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {						# inline rules
	resource := input.document[i].Resources[security_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	resource.Properties.GroupName == "default"
	search_values := check_rules(resource.Properties, security_group_name, input.document[i])
	search_values != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "AWS::EC2::SecurityGroup",
		"resourceName": cf_lib.get_resource_name(resource, security_group_name),
		"searchKey": search_values.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Any 'AWS::EC2::SecurityGroup' with 'Properties.GroupName' set to 'default' should not have any traffic rules set.",
		"keyActualValue": sprintf("'Resources.%s' has 'Properties.GroupName' set to 'default' and traffic rules set in 'Properties'.", [security_group_name]),
		"searchLine": search_values.searchLine
	}
}

CxPolicy[result] {						# standalone rules
	resource := input.document[i].Resources[security_group_name]
	resource.Type == "AWS::EC2::SecurityGroup"

	resource.Properties.GroupName == "default"
	rules := search_for_standalone_rules(security_group_name, input.document[i])
	rule := rules.rule_list[x]

	search_values := check_standalone_rule(security_group_name, rule, rules.names[x])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "AWS::EC2::SecurityGroup",
		"resourceName": cf_lib.get_resource_name(resource, security_group_name),
		"searchKey": search_values.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Any 'AWS::EC2::SecurityGroup' with 'Properties.GroupName' set to 'default' should not have any traffic rules set.",
		"keyActualValue": sprintf("'Resources.%s' has 'Properties.GroupName' set to 'default' and a standalone '%s' rule set.", [security_group_name, rule.Type]),
		"searchLine": search_values.searchLine
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
} else = { "rule_list": [], "names": []}


check_standalone_rule(security_group_name, rule, rule_name) = search_values {

	cf_lib.get_name(rule.Properties.GroupId) == security_group_name

	search_values := {
		"searchKey" : sprintf("Resources.%s.Properties.GroupId", [rule_name]),
		"searchLine" : common_lib.build_search_line(["Resources", rule_name, "Properties", "GroupId"], [])
	}
}

check_rules(properties, security_group_name, doc) = search_values {
	inline_rules := ["SecurityGroupIngress","SecurityGroupEgress"]
	count(properties[inline_rules[_]]) != 0

	search_values := {
		"searchKey" : sprintf("Resources.%s.Properties", [security_group_name]),
		"searchLine" : common_lib.build_search_line(["Resources", security_group_name, "Properties"], [])
	}
}
