package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.KeyVault/vaults"

	fields := {"enableSoftDelete", "enablePurgeProtection"}
	not common_lib.valid_key(value.properties, fields[x])

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.KeyVault/vaults' should have '%s' property defined", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.KeyVault/vaults' doesn't have '%s' property defined", [fields[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties"]),
		"searchValue": sprintf("%s",[fields[x]]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.KeyVault/vaults"

	fields := {"enableSoftDelete", "enablePurgeProtection"}

	[val, type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties[fields[x]])
	val == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.%s", [common_lib.concat_path(path), value.name, fields[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.KeyVault/vaults' %s should have '%s' property set to true", [type, fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.KeyVault/vaults' doesn't have '%s' property set to true", [fields[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties", fields[x]]),
		"searchValue": sprintf("%s",[fields[x]]),
	}
}
