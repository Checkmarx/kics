package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)

	value.type == "Microsoft.ContainerService/managedClusters"
	not is_filled(value)

	issue := prepare_issue(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, issue.sk]),
		"issueType": issue.issueType,
		"keyExpectedValue": "'networkProfile.networkPolicy' should be defined and not empty",
		"keyActualValue": issue.keyActualValue,
		"searchLine": common_lib.build_search_line(path, issue.sl),
	}
}

is_filled(value) {
	value.properties.networkProfile.networkPolicy != ""
}

prepare_issue(resource) = issue {
	resource.properties.networkProfile.networkPolicy == ""
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "IncorrectValue",
		"keyActualValue": "'networkProfile.networkPolicy' is empty",
		"sk": ".properties.networkProfile.networkPolicy",
		"sl": ["properties", "networkProfile", "networkPolicy"],
	}
} else = issue {
	issue := {
		"resourceType": resource.type,
		"resourceName": resource.name,
		"issueType": "MissingAttribute",
		"keyActualValue": "'networkProfile.networkPolicy' is undefined",
		"sk": "",
		"sl": ["name"],
	}
}
