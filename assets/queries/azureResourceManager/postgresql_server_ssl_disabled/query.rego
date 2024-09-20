package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers"

	not common_lib.valid_key(value.properties, "sslEnforcement")

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' should have 'sslEnforcement' property defined",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' doesn't have 'sslEnforcement' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers"

	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.sslEnforcement)
	lower(val) == "disabled"

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.sslEnforcement", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.DBforPostgreSQL/servers' should have 'sslEnforcement' %s set to 'Enabled'", [val_type]),
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' doesn't have 'sslEnforcement' property set to 'Enabled'",
		"searchLine": common_lib.build_search_line(path, ["properties", "sslEnforcement"]),
	}
}
