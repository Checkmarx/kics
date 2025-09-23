package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

    not common_lib.valid_key(container, "imagePullPolicy")

	not contains(container.image, "@") # digest
	not contains(container.image, ":latest") # image with latest tag
	contains(container.image, ":") # any tag

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.imagePullPolicy should be set to 'Always'", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.imagePullPolicy relies on mutable images in cache", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

	container.imagePullPolicy != "Always"

	not contains(container.image, "@") # digest
	not contains(container.image, ":latest") # image with latest tag
	contains(container.image, ":") # any tag

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.imagePullPolicy", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.imagePullPolicy should be set to 'Always'", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.imagePullPolicy relies on mutable images in cache", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "imagePullPolicy"]),
	}
}
