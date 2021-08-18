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
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'encryptionSettingsCollection.enabled' is set to true",
		"keyActualValue": issue.keyActualValue,
	}
}

prepare_issue(resource) = issue {
	resource.properties.encryptionSettingsCollection.enabled == false
	issue := {
		"issueType": "IncorrectValue",
		"keyActualValue": "'encryptionSettingsCollection.enabled' is set to false",
		"sk": ".properties.encryptionSettingsCollection.enabled",
	}
} else = issue {
	issue := {
		"issueType": "MissingAttribute",
		"keyActualValue": "'encryptionSettingsCollection.enabled' is undefined",
		"sk": "",
	}
}
