package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroupEgress"

	properties := resource.Properties

	properties.IpProtocol == "-1"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.IpProtocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.IpProtocol should not be set to '-1'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.IpProtocol is set to '-1'", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["IpProtocol"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	properties := resource.Properties

	properties.SecurityGroupEgress[index].IpProtocol == "-1"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupEgress.IpProtocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].IpProtocol should not be set to '-1'", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].IpProtocol is set to '-1'", [name, index]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupEgress", index], ["IpProtocol"]),
	}
}
