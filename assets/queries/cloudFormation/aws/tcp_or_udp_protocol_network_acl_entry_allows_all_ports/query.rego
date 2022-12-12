package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::NetworkAclEntry"

	properties := resource.Properties

	checkProtocol(properties.Protocol)

	not common_lib.valid_key(properties, "PortRange")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PortRange should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PortRange is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::NetworkAclEntry"

	properties := resource.Properties

	checkProtocol(properties.Protocol)

	attributes := {"From", "To"}
	attr := attributes[y]
	not common_lib.valid_key(properties.PortRange, attr)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PortRange", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PortRange.%s should be set", [name, y]),
		"keyActualValue": sprintf("Resources.%s.Properties.PortRange.%s is undefined", [name, y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::NetworkAclEntry"

	properties := resource.Properties
	checkProtocol(properties.Protocol)

	properties.PortRange.From == 0
	properties.PortRange.To == 65535

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PortRange", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PortRange should not allow all ports", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PortRange allows all ports", [name]),
	}
}

checkProtocol(protocol) = allow {
	protocols := {6, 17}
	protocol == protocols[x]

	allow = true
}
