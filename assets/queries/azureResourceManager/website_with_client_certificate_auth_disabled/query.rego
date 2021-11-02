package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties, "clientCertEnabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'clientCertEnabled' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	value.properties.clientCertEnabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.clientCertEnabled", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'clientCertEnabled' property set to true",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' set to true",
		"searchLine": common_lib.build_search_line(path, ["properties", "clientCertEnabled"]),
	}
}
