package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.Security/securityContacts"

	not common_lib.valid_key(value.properties, "phone")

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' should have 'phone' property defined",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'phone' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}
