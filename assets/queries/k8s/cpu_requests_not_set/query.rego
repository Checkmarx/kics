package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]

	not common_lib.valid_key(containers[index].resources.requests, "cpu")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchValue": document.kind,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.requests", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name={{%s}}.resources.requests should have CPU requests", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name={{%s}}.resources.requests doesn't have CPU requests", [specInfo.path, types[x], containers[index].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], index, "resources", "requests"]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]

	not common_lib.valid_key(containers[index].resources, "requests")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchValue": document.kind,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s.resources should have requests defined", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s.resources doesn't have requests defined", [specInfo.path, types[x], containers[index].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], index, "resources"]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]

	not common_lib.valid_key(containers[index], "resources")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchValue": document.kind,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name=%s", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s should have resources defined", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s doesn't have resources defined", [specInfo.path, types[x], containers[index].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], index]),
	}
}
