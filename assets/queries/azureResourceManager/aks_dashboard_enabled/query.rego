package Cx

import data.generic.common as common_lib

# addonProfiles not implemented (apiVersion < 2017-08-03)
CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.ContainerService/managedClusters"
	value.apiVersion == "2017-08-03"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.apiVersion", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'apiVersion' is not '2017-08-03'",
		"keyActualValue": "'apiVersion' is '2017-08-03'",
	}
}

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)
	value.type == "Microsoft.ContainerService/managedClusters"
	value.apiVersion != "2017-08-03"
	not dashboard_is_disabled(value)

	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'addonProfiles.kubeDashboard.enabled' is defined and false",
		"keyActualValue": issue.keyActualValue,
	}
}

dashboard_is_disabled(resource) {
	common_lib.valid_key(resource, "properties")
	common_lib.valid_key(resource.properties, "addonProfiles")
	common_lib.valid_key(resource.properties.addonProfiles, "kubeDashboard")
	common_lib.valid_key(resource.properties.addonProfiles.kubeDashboard, "enabled")
	resource.properties.addonProfiles.kubeDashboard.enabled == false
}

prepare_issue(resource) = issue {
	_ = resource.properties.addonProfiles.kubeDashboard.enabled
	issue := {
		"issueType": "IncorrectValue",
		"keyActualValue": "'addonProfiles.kubeDashboard.enabled' is false",
		"sk": ".properties.addonProfiles.kubeDashboard.enabled",
	}
} else = issue {
	issue := {
		"issueType": "MissingAttribute",
		"keyActualValue": "'addonProfiles.kubeDashboard.enabled' is undefined",
		"sk": "",
	}
}
