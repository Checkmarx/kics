package Cx

import data.generic.azureresourcemanager as arm_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Network/networkSecurityGroups"

	properties := value.properties.securityRules[x].properties

	properties.access == "Allow"
	lower(properties.protocol) == "tcp"
	properties.direction == "Inbound"
	arm_lib.contains_port(properties, 22)
	arm_lib.source_address_prefix_is_open(properties)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.securityRules", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type '%s' restricts access to SSH", [value.type]),
		"keyActualValue": sprintf("resource with type '%s' does not restrict access to SSH", [value.type]),
		"searchLine": common_lib.build_search_line(path, ["properties", "securityRules", x, "properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	typeInfo := arm_lib.get_sg_info(value)

	properties := typeInfo.properties

	properties.access == "Allow"
	lower(properties.protocol) == "tcp"
	properties.direction == "Inbound"
	arm_lib.contains_port(properties, 22)
	arm_lib.source_address_prefix_is_open(properties)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s", [typeInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type '%s' restricts access to SSH", [typeInfo.type]),
		"keyActualValue": sprintf("resource with type '%s' does not restrict access to SSH", [typeInfo.type]),
		"searchLine": common_lib.build_search_line(path, typeInfo.sl),
	}
}
