package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	security_group := doc.Resources[security_group_name]
	security_group.Type == "AWS::EC2::SecurityGroup"

	security_group.Properties.GroupName == "default"
	search_values := check_rules(security_group.Properties, security_group_name, doc)
	search_values != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "AWS::EC2::SecurityGroup",
		"resourceName": cf_lib.get_resource_name(security_group, security_group_name),
		"searchKey": search_values.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.GroupName defined as 'default' should not have any inbound or outbound rules set.", [security_group_name]),
		"keyActualValue": sprintf("Resources.%s.Properties.GroupName is defined as 'default' and has inbound or outbound rules set.", [security_group_name]),
		"searchLine": search_values.searchLine
	}
}

check_rules(properties, security_group_name, doc) = search_values {
	inline_rules := ["SecurityGroupIngress","SecurityGroupEgress"]
	count(properties[inline_rules[_]]) != 0

	search_values := {
		"searchKey" : sprintf("Resources.%s.Properties", [security_group_name]),
		"searchLine" : common_lib.build_search_line(["Resources", security_group_name, "Properties"], [])
	}
} else = search_values {
	standalone_traffic_rules := {"AWS::EC2::SecurityGroupIngress", "AWS::EC2::SecurityGroupEgress"}

	traffic_rule := doc.Resources[traffic_rule_name]
	traffic_rule.Type == standalone_traffic_rules[t]
	
	cf_lib.get_name(traffic_rule.Properties.GroupId) == security_group_name

	search_values := {
		"searchKey" : sprintf("Resources.%s.Properties.GroupId", [traffic_rule_name]),
		"searchLine" : common_lib.build_search_line(["Resources", traffic_rule_name, "Properties", "GroupId"], [])
	}
}
