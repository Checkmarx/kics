package Cx

import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	image := trim(container.image, " ")
	image != ""
	not contains(image, "@") # digest is even better than tag
	isTagInvalid(image)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image tag is provided and not latest", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image tag is not provided or latest", [metadata.name, specInfo.path, types[x], container.name]),
	}
}

isTagInvalid(image) {
	not contains(image, ":") # any tag
} else {
	endswith(image, ":latest") # image with latest tag
}
