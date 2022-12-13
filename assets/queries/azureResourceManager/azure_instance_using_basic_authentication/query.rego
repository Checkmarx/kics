package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Compute/virtualMachines"
	not is_windows(value)
	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'disablePasswordAuthentication' should be set to true",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

is_windows(resource) {
	validMSWindowsVer := ["windows", "microsoft"]
	contains(lower(resource.properties.storageProfile.imageReference.publisher), validMSWindowsVer[_])
}

prepare_issue(resource) = issue {
	resource.properties.osProfile.linuxConfiguration.disablePasswordAuthentication == false
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": "'disablePasswordAuthentication' is set to false",
		"sk": ".properties.osProfile.linuxConfiguration.disablePasswordAuthentication",
		"sl": ["properties", "osProfile", "linuxConfiguration", "disablePasswordAuthentication"],
	}
} else = issue {
	not resource.properties.osProfile.linuxConfiguration.disablePasswordAuthentication
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'linuxConfiguration.disablePasswordAuthentication' is not defined",
		"sk": "",
		"sl": ["name"],

	}
}
