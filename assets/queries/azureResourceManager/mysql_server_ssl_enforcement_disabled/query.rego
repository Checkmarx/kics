package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.DBforMySQL/servers"
	not common_lib.valid_key(value.properties, "sslEnforcement")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforMySQL/servers' has the 'sslEnforcement' property defined",
		"keyActualValue": "resource with type 'Microsoft.DBforMySQL/servers' doesn't have 'sslEnforcement' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.DBforMySQL/servers"
	value.properties.sslEnforcement == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.sslEnforcement", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.DBforMySQL/servers' has the 'sslEnforcement' property set to 'Enabled'",
		"keyActualValue": "resource with type 'Microsoft.DBforMySQL/servers' doesn't have 'sslEnforcement' set to 'Enabled'",
		"searchLine": common_lib.build_search_line(path, ["properties", "sslEnforcement"]),
	}
}
