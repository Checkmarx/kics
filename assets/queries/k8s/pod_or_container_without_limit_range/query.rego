package Cx

import data.generic.k8s as k8s_lib
import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8s_lib.getSpecInfo(document)
	metadata := document.metadata

	pod_or_container(specInfo, document)

	namespace := document.metadata.namespace

	count({ x | doc := input.document[x]; doc.kind == "LimitRange"; doc.metadata.namespace == namespace}) == 0

	result := {
		"documentId": document.id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}.namespace", [metadata.name]),
		"keyExpectedValue": sprintf("metadata.name={{%s}} has a 'LimitRange' associated", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}} does not have a 'LimitRange' associated", [metadata.name]),
		"searchLine": common_lib.build_search_line(["metadata", "namespace"], [])
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8s_lib.getSpecInfo(document)
	metadata := document.metadata

	pod_or_container(specInfo, document)

	is_default(document)

	count({ x | doc := input.document[x]; doc.kind == "LimitRange"; is_default(doc)}) == 0

	result := {
		"documentId": document.id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"keyExpectedValue": sprintf("metadata.name={{%s}} has a 'LimitRange' associated", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}} does not have a 'LimitRange' associated", [metadata.name]),
		"searchLine": common_lib.build_search_line(["metadata"], [])
	}
}

is_default(document) {
	document.metadata.namespace == "default"
} else {
	not common_lib.valid_key(document.metadata, "namespace")
}


pod_or_container(specInfo, document) {
	specInfo.spec[types[x]]
	document.kind != "Pod"
} else {
	document.kind == "Pod"
}
