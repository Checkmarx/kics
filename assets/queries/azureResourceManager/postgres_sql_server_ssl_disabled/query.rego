package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers"

	not common_lib.valid_key(value.properties, "sslEnforcement")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' has 'sslEnforcement' property defined",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' doesn't have 'sslEnforcement' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers"
	
	lower(value.properties.sslEnforcement) == "disabled"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name={{%s}}.properties.sslEnforcement", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' has 'sslEnforcement' property set to 'Enabled'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' doesn't have 'sslEnforcement' property set to 'Enabled'",
		"searchLine": common_lib.build_search_line(path, ["properties", "sslEnforcement"]),
	}
}
