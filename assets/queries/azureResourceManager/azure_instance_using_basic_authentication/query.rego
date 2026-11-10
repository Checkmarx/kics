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
		"keyExpectedValue": issue.keyExpectedValue,
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

# OS can only be inferred from linuxConfiguration, osDisk.osType or an image publisher
is_linux(resource) {
	resource.properties.osProfile.linuxConfiguration
} else {
	lower(resource.properties.storageProfile.osDisk.osType) == "linux"
} else {
	is_string(resource.properties.storageProfile.imageReference.publisher)
}

is_windows(resource) {
	resource.properties.osProfile.windowsConfiguration
} else {
	lower(resource.properties.storageProfile.osDisk.osType) == "windows"
} else {
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
		"keyExpectedValue": "'disablePasswordAuthentication' should be set to true",
		"keyActualValue": sprintf("'disablePasswordAuthentication' %s is set to false",[dpa_type]),
		"sk": ".properties.osProfile.linuxConfiguration.disablePasswordAuthentication",
		"sl": ["properties", "osProfile", "linuxConfiguration", "disablePasswordAuthentication"],
	}
} else = issue {
	not resource.properties.osProfile.linuxConfiguration.disablePasswordAuthentication
	is_linux(resource)

	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'disablePasswordAuthentication' should be set to true",
		"keyActualValue": "'linuxConfiguration.disablePasswordAuthentication' is not defined",
		"sk": "",
		"sl": ["name"],
	}
} else = issue {
	not resource.properties.osProfile.linuxConfiguration.disablePasswordAuthentication

	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'osProfile' authentication should be defined ('linuxConfiguration.disablePasswordAuthentication' set to true if the OS is Linux)",
		"keyActualValue": "Authentication is undefined and the OS type could not be determined",
		"sk": "",
		"sl": ["name"],
	}
}
