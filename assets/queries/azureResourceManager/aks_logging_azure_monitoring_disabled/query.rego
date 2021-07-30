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
	not value.properties.addonProfiles.omsagent.enabled

	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'addonProfiles.omsagent.enabled' is defined and false",
		"keyActualValue": issue.keyActualValue,
	}
}

prepare_issue(resource) = issue {
	_ = resource.properties.addonProfiles.omsagent.enabled
	issue := {
		"issueType": "IncorrectValue",
		"keyActualValue": "'addonProfiles.omsagent.enabled' is false",
		"sk": ".properties.addonProfiles.omsagent.enabled",
	}
} else = issue {
	issue := {
		"issueType": "MissingAttribute",
		"keyActualValue": "'addonProfiles.omsagent.enabled' is undefined",
		"sk": "",
	}
}
