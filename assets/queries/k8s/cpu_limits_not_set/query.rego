package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]

	not common_lib.valid_key(containers[index].resources.limits, "cpu")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.limits", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s has CPU limits", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s doesn't have CPU limits", [specInfo.path, types[x], containers[index].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]

	not common_lib.valid_key(containers[index].resources, "limits")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s has limits defined", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s doesn't have limits defined", [specInfo.path, types[x], containers[index].name]),
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
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name=%s", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s has resources defined", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s doesn't have resources defined", [specInfo.path, types[x], containers[index].name]),
	}
}
