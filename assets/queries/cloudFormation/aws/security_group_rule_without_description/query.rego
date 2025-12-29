package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

types := ["AWS::RDS::DBSecurityGroup", "AWS::EC2::SecurityGroup"]

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == types[_]

	not common_lib.valid_key(resource.Properties, "GroupDescription")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.GroupDescription should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.GroupDescription is undefined", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := {"SecurityGroupIngress", "SecurityGroupEgress"}
	prop := resource.Properties[properties[index]][j]
	not common_lib.valid_key(prop, "Description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.%s", [name, properties[index]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.%s[%d].Description should be set", [name, properties[index], j]),
		"keyActualValue": sprintf("Resources.%s.Properties.%s[%d].Description is undefined", [name, properties[index], j]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", properties[index], j], []),
	}
}

CxPolicy[result] {
	resourceTypes := {"AWS::EC2::SecurityGroupIngress", "AWS::EC2::SecurityGroupEgress"}
	resource := input.document[i].Resources[name]

	resourceTypes[resource.Type]

	not common_lib.valid_key(resource.Properties, "Description")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Description should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Description is undefined", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
