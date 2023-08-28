package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	rule := resource.Properties.SecurityGroupIngress[index]

	entireNetwork(rule)
	isTCP(rule.IpProtocol)
	rule.FromPort <= 80

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SecurityGroupIngress", [cf_lib.getPath(path),name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupIngress", index, "FromPort"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] should not open the HTTP port (80)", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] opens the HTTP port (80)", [name, index]),
	}
}


CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"

	rule := resource.Properties.SecurityGroupIngress[index]

	entireNetwork(rule)
	isTCP(rule.IpProtocol)
	rule.ToPort >= 80

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SecurityGroupIngress", [cf_lib.getPath(path),name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "SecurityGroupIngress", index, "ToPort"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] should not open the HTTP port (80)", [name, index]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityGroupIngress[%d] opens the HTTP port (80)", [name, index]),
	}
}

entireNetwork(rule) {
	rule.CidrIp == "0.0.0.0/0"
}

entireNetwork(rule) {
	rule.CidrIpv6 == "::/0"
}

isTCP("tcp") = true

isTCP("-1") = true

isTCP("6") = true