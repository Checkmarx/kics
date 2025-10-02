package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, Resources] := walk(doc)
	resource := Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"
	security_group_properties := resource.Properties
	security_group_properties.GroupName == "default"
	search_values := check_rules(security_group_properties, path, name, doc)
	search_values != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": search_values.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.GroupName defined as 'default' should not have any inbound or outbound rules set.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.GroupName is defined as 'default' and has inbound or outbound rules set.", [name]),
		"searchLine": search_values.searchLine
	}
}


check_rules(security_group_properties, raw_path, security_group_name, doc) = search_values {
	inline_traffic_rules := {"SecurityGroupIngress", "SecurityGroupEgress"}
	count(security_group_properties[inline_traffic_rules[_]]) != 0

	path := cf_lib.getPath(raw_path)

	search_values := {
		"searchKey" : sprintf("%s%s.Properties", [path, security_group_name]),
		"searchLine" : common_lib.build_search_line(raw_path, [security_group_name, "Properties"])
	}
} else = search_values {
	standalone_traffic_rules := {"AWS::EC2::SecurityGroupIngress", "AWS::EC2::SecurityGroupEgress"}
	
	[rule_raw_path, Resources] := walk(doc)
	resource := Resources[traffic_rule_name]
	resource.Type == standalone_traffic_rules[t]
	
	path := cf_lib.getPath(rule_raw_path)
	cf_lib.get_name(resource.Properties.GroupId) == security_group_name

	search_values := {
		"searchKey" : sprintf("%s%s.Properties.GroupId", [path, traffic_rule_name]),
		"searchLine" : common_lib.build_search_line(rule_raw_path, [traffic_rule_name, "Properties", "GroupId"])
	}
}
