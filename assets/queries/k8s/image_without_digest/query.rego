package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

	not contains(container.image, "@")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind,
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image should specify the image with a digest", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image does not include an image digest", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "image"]),
	}
}
