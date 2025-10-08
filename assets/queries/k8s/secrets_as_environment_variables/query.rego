package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

containers := ["containers", "initContainers"]

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := k8sLib.getSpecInfo(document)

	specInfo.spec[containers[c]][j].env[k].valueFrom.secretKeyRef

	container_name := specInfo.spec[containers[c]][j].name
	env_name := specInfo.spec[containers[c]][j].env[k].name

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.env.name={{%s}}.valueFrom.secretKeyRef", [metadata.name, specInfo.path, containers[c], env_name]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # different kinds can match the same spec structure
		"keyExpectedValue": sprintf("'%s.%s.name={{%s}}.env.name={{%s}}.valueFrom.secretKeyRef' should be undefined", [specInfo.path, containers[c], container_name, env_name]),
		"keyActualValue": sprintf("'%s.%s.name={{%s}}.env.name={{%s}}.valueFrom.secretKeyRef' is defined", [specInfo.path, containers[c], container_name, env_name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [containers[c], j, "env", k, "valueFrom", "secretKeyRef"]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := k8sLib.getSpecInfo(document)

	specInfo.spec[containers[c]][j].envFrom[k].secretRef

	container_name := specInfo.spec[containers[c]][j].name

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.envFrom", [metadata.name, specInfo.path, containers[c], container_name]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # different kinds can match the same spec structure
		"keyExpectedValue": sprintf("'%s.%s.name={{%s}}.envFrom.secretRef' should be undefined", [specInfo.path, containers[c], container_name]),
		"keyActualValue": sprintf("'%s.%s.name={{%s}}.envFrom.secretRef' is defined", [specInfo.path, containers[c], container_name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [containers[c], j, "envFrom", k, "secretRef"]),
	}
}
