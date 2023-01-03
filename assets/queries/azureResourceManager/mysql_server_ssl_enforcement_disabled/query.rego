package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.DBforMySQL/servers"
	not common_lib.valid_key(value.properties, "sslEnforcement")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforMySQL/servers' should have the 'sslEnforcement' property defined",
		"keyActualValue": "resource with type 'Microsoft.DBforMySQL/servers' doesn't have 'sslEnforcement' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.DBforMySQL/servers"
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.sslEnforcement)
	val == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.sslEnforcement", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.DBforMySQL/servers' should have the 'sslEnforcement' %s set to 'Enabled'", [val_type]),
		"keyActualValue": "resource with type 'Microsoft.DBforMySQL/servers' doesn't have 'sslEnforcement' set to 'Enabled'",
		"searchLine": common_lib.build_search_line(path, ["properties", "sslEnforcement"]),
	}
}
