package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azure_virtual_network[name]
	not common_lib.valid_key(resource.subnet, "security_group")

	result := {
		"documentId": document.id,
		"resourceType": "azure_virtual_network",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azure_virtual_network[%s].subnet", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azure_virtual_network[%s].subnet.security_group' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azure_virtual_network[%s].subnet.security_group' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.azure_virtual_network[name]
	count(resource.subnet.security_group) == 0

	result := {
		"documentId": document.id,
		"resourceType": "azure_virtual_network",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azure_virtual_network[%s].subnet.security_group", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azure_virtual_network[%s].subnet.security_group' should not be empty", [name]),
		"keyActualValue": sprintf("'azure_virtual_network[%s].subnet.security_group' is empty", [name]),
	}
}
