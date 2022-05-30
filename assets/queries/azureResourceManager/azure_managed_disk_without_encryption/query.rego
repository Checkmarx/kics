package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Compute/disks"
	not value.properties.encryptionSettingsCollection.enabled

	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'encryptionSettingsCollection.enabled' is set to true",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

prepare_issue(resource) = issue {
	resource.properties.encryptionSettingsCollection.enabled == false
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": "'encryptionSettingsCollection.enabled' is set to false",
		"sk": ".properties.encryptionSettingsCollection.enabled",
		"sl": ["properties", "encryptionSettingsCollection", "enabled"],
	}
} else = issue {
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'encryptionSettingsCollection.enabled' is undefined",
		"sk": "",
		"sl": ["name"],
	}
}
