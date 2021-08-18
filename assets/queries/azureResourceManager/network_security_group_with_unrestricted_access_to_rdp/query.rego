package Cx

import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	typeInfo := arm_lib.get_sg_info(value)

	properties := typeInfo.properties

	properties.access == "Allow"
	properties.protocol == "Tcp"
	properties.direction == "Inbound"
	arm_lib.contains_port(properties, 3389)
	arm_lib.source_address_prefix_is_open(properties)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s", [typeInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type '%s' restricts access to RDP", [typeInfo.type]),
		"keyActualValue": sprintf("resource with type '%s' does not restrict access to RDP", [typeInfo.type]),
	}
}
