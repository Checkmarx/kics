package Cx

import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	imagePullPolicy := object.get(container, "imagePullPolicy", {})
	imagePullPolicy != "Always"

	not contains(container.image, "@") # digest
	not contains(container.image, ":latest") # image with latest tag
	contains(container.image, ":") # any tag

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.imagePullPolicy", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.imagePullPolicy should be set to 'Always'", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.imagePullPolicy relies on mutable images in cache", [metadata.name, specInfo.path, types[x], container.name]),
	}
}
