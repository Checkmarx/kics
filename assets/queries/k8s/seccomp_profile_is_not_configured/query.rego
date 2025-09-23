package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

# seccompProfile since Kubernetes v1.19 - container defines seccompProfile.type
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

    container := specInfo.spec[types[x]][c]

	profile := container.securityContext.seccompProfile.type
	not any([profile == "RuntimeDefault", profile == "Localhost"])

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type=%s", [metadata.name, specInfo.path, types[x], container.name, profile]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type should be set to 'RuntimeDefault' or 'Localhost'", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type is set to '%s'", [metadata.name, specInfo.path, types[x], container.name, profile]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "securityContext", "seccompProfile", "type"]),
	}
}

# seccompProfile since Kubernetes v1.19 - pod defines seccompProfile.type and container inherits this setting
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	container := specInfo.spec[types[x]][_]

	containerSeccompType := common_lib.get_nested_values_info(container, ["securityContext", "seccompProfile", "type"])
	containerSeccompType.valid == false

	profile := specInfo.spec.securityContext.seccompProfile.type
	not any([profile == "RuntimeDefault", profile == "Localhost"])

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.securityContext.seccompProfile.type=%s", [metadata.name, specInfo.path, profile]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.securityContext.seccompProfile.type should be set to 'RuntimeDefault' or 'Localhost'", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.securityContext.seccompProfile.type is set to '%s'", [metadata.name, specInfo.path, profile]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), ["securityContext", "seccompProfile", "type"]),
	}
}

# seccompProfile since Kubernetes v1.19 - neither pod nor container define seccompProfile.type
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
    container :=  specInfo.spec[types[x]][c]

	specSeccompType := common_lib.get_nested_values_info(specInfo.spec, ["securityContext", "seccompProfile", "type"])
	specSeccompType.valid == false

	containerSeccompType := common_lib.get_nested_values_info(container, ["securityContext", "seccompProfile", "type"])
	containerSeccompType.valid == false

	not hasSeccompAnnotation(document)
	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": common_lib.remove_last_point(sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.%s", [metadata.name, specInfo.path, types[x], container.name, containerSeccompType.searchKey])),
		"issueType": "MissingAttribute",
		"searchValue": document.kind, # multiple kind can match the same spec structure
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type should be defined", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type is undefined", [metadata.name, specInfo.path, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), array.concat([types[x], c], containerSeccompType.searchLine)),
	}
}
# seccomp annotations until Kubernetes v1.19, deprecated and removed with v1.25
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	[path, value] = walk(document)
	annotations := value.metadata.annotations

	seccompAnnotation := "seccomp.security.alpha.kubernetes.io/defaultProfileName"
	common_lib.valid_key(annotations, seccompAnnotation)
	seccomp := annotations[seccompAnnotation]
	seccomp != "runtime/default"

	# if annotations are in pod metadata, path is empty -> strip redundant dot
	seccompAnnotationPath := trim_left(sprintf("%s.annotations.%s", [common_lib.concat_path(path), seccompAnnotation]), ".")
	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, seccompAnnotationPath]),
		"issueType": "IncorrectValue",
		"searchValue": document.kind,
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s is 'runtime/default'", [metadata.name, seccompAnnotationPath]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s is '%s'", [metadata.name, seccompAnnotationPath, seccomp]),
		"searchLine": common_lib.build_search_line(path, ["metadata","annotations",seccompAnnotation]),
	}
}

hasSeccompAnnotation(document) {
	[path, value] = walk(document)
	annotations := value.metadata.annotations

	seccompAnnotation := "seccomp.security.alpha.kubernetes.io/defaultProfileName"
	common_lib.valid_key(annotations, seccompAnnotation)
}
