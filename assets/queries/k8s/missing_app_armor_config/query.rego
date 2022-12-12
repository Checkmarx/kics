package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

getMetadataInfo(document) = metadataInfo {
	templates := {"job_template", "jobTemplate"}
	metadata := document.spec[templates[t]].spec.template.metadata
	metadataInfo := {"metadata": metadata, "path": sprintf("spec.%s.spec.template.metadata", [templates[t]])}
} else = metadataInfo {
	metadata := document.spec.template.metadata
	metadataInfo := {"metadata": metadata, "path": "spec.template.metadata"}
} else = metadataInfo {
	metadata := document.metadata
	metadataInfo := {"metadata": metadata, "path": ""}
}

isValidAppArmorProfile(profile) {
	profile == "runtime/default"
} else {
	startswith(profile, "localhost/")
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_].name

	metadataInfo := getMetadataInfo(document)
	annotations := object.get(metadataInfo.metadata, "annotations", {})
	expectedKey := sprintf("container.apparmor.security.beta.kubernetes.io/%s", [container])

	not isValidAppArmorProfile(annotations[expectedKey])

	annotationsPath := trim_left(sprintf("%s.annotations", [metadataInfo.path]), ".")
	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, annotationsPath]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s[%s] should be set to 'runtime/default' or 'localhost'", [metadata.name, annotationsPath, expectedKey]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s[%s] does not specify a valid AppArmor profile", [metadata.name, annotationsPath, expectedKey]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_].name

	metadataInfo := getMetadataInfo(document)
	annotations := object.get(metadataInfo.metadata, "annotations", {})
	expectedKey := sprintf("container.apparmor.security.beta.kubernetes.io/%s", [container])

	not common_lib.valid_key(annotations, expectedKey)

	annotationsPath := trim_left(sprintf("%s.annotations", [metadataInfo.path]), ".")
	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": trim_right(sprintf("metadata.name={{%s}}.%s", [metadata.name, metadataInfo.path]), "."),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s should specify an AppArmor profile for container {{%s}}", [metadata.name, annotationsPath, container]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s does not specify an AppArmor profile for container {{%s}}", [metadata.name, annotationsPath, container]),
		"searchLine": common_lib.build_search_line(split(annotationsPath, "."), [])
	}
}
