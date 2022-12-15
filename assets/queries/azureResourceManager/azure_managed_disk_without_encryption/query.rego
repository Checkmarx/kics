package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Compute/disks"
	arm_lib.isDisabledOrUndefined(doc, value.properties, "encryptionSettingsCollection.enabled")

	issue := prepare_issue(doc, value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'encryptionSettingsCollection.enabled' should be set to true",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

prepare_issue(doc, resource) = issue {
	[e_value, e_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, resource.properties.encryptionSettingsCollection.enabled)
	e_value == false
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": sprintf("'encryptionSettingsCollection.enabled' %s is set to false", [e_type]),
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
