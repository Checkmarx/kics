package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.Compute/virtualMachines"
	not is_windows(value)
	arm_lib.isDisabledOrUndefined(doc, value.properties, "osProfile.linuxConfiguration.disablePasswordAuthentication")	

	issue := prepare_issue(doc, value)


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


prepare_issue(doc, resource) = issue {
	disablePasswordAuthentication:= resource.properties.osProfile.linuxConfiguration.disablePasswordAuthentication
	[dpa_value, dpa_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, disablePasswordAuthentication)
	dpa_value == false

	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": sprintf("'disablePasswordAuthentication' %s is set to false",[dpa_type]),
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
