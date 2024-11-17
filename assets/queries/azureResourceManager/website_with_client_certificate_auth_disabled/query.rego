package Cx

import data.generic.azureresourcemanager as arm_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties, "clientCertEnabled")

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' should have the 'clientCertEnabled' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	some doc in input.document
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"

	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.clientCertEnabled)
	val == false

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.clientCertEnabled", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Web/sites' should have the 'clientCertEnabled' %s set to true", [val_type]),
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' set to true",
		"searchLine": common_lib.build_search_line(path, ["properties", "clientCertEnabled"]),
	}
}
