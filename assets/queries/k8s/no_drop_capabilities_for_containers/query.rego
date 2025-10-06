package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]

	cap := containers[c].securityContext.capabilities
	not common_lib.valid_key(cap, "drop")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities", [metadata.name, types[x], containers[c].name]),
		"issueType": "MissingAttribute",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("spec.%s[%s].securityContext.capabilities.drop should be defined", [types[x], containers[c].name]),
		"keyActualValue": sprintf("spec.%s[%s].securityContext.capabilities.drop is not defined", [types[x], containers[c].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "securityContext", "capabilities"]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]
    containerSec := containers[k].securityContext
	not common_lib.valid_key(containerSec, "capabilities")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext", [metadata.name, types[x], containers[k].name]),
		"issueType": "MissingAttribute",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities should be set", [metadata.name, types[x], containers[k].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities is undefined", [metadata.name, types[x], containers[k].name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], k, "securityContext"]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]

	not common_lib.valid_key(containers[k], "securityContext")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name=%s", [metadata.name, types[x], containers[k].name]),
		"issueType": "MissingAttribute",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name=%s.securityContext should be set", [metadata.name, types[x], containers[k].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name=%s.securityContext is undefined", [metadata.name, types[x], containers[k].name]),
        "searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], k]),
	}
}
