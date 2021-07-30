package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Compute/virtualMachines"
	not is_windows(value)
	not value.properties.osProfile.linuxConfiguration.disablePasswordAuthentication

	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'disablePasswordAuthentication' is set to true",
		"keyActualValue": issue.keyActualValue,
	}
}

is_windows(resource) {
	contains(lower(resource.properties.storageProfile.imageReference.publisher), "windows")
}

prepare_issue(resource) = issue {
	resource.properties.osProfile.linuxConfiguration.disablePasswordAuthentication == false
	issue := {
		"issueType": "IncorrectValue",
		"keyActualValue": "'disablePasswordAuthentication' is set to false",
		"sk": ".properties.osProfile.linuxConfiguration.disablePasswordAuthentication",
	}
} else = issue {
	issue := {
		"issueType": "MissingAttribute",
		"keyActualValue": "'disablePasswordAuthentication' is undefined",
		"sk": "",
	}
}
