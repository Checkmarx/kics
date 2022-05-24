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
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.apiVersion", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'apiVersion' is not '2017-08-03'",
		"keyActualValue": "'apiVersion' is '2017-08-03'",
		"searchLine": common_lib.build_search_line(path, ["apiVersion"]),
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
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'addonProfiles.omsagent.enabled' is defined and false",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

prepare_issue(resource) = issue {
	_ = resource.properties.addonProfiles.omsagent.enabled
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": "'addonProfiles.omsagent.enabled' is false",
		"sk": ".properties.addonProfiles.omsagent.enabled",
		"sl": ["properties", "addonProfiles", "omsagent", "enabled"],
	}
} else = issue {
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'addonProfiles.omsagent.enabled' is undefined",
		"sk": "",
		"sl": ["name"],
	}
}
