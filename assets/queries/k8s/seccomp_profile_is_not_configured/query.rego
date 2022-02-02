package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

# container defines seccompProfile.type
checkSeccompProfile(specInfo, container, containerType, document, metadata) = result {
	profile := container.securityContext.seccompProfile.type
	not any([profile == "RuntimeDefault", profile == "Localhost"])

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type=%s", [metadata.name, specInfo.path, containerType, container.name, profile]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type should be set to 'RuntimeDefault' or 'Localhost'", [metadata.name, specInfo.path, containerType, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type is set to '%s'", [metadata.name, specInfo.path, containerType, container.name, profile]),
	}
}

# pod defines seccompProfile.type and container inherits this setting
checkSeccompProfile(specInfo, container, containerType, document, metadata) = result {
	containerCtx := object.get(container.securityContext, "seccompProfile", {})
	not common_lib.valid_key(containerCtx, "type")

	profile := specInfo.spec.securityContext.seccompProfile.type
	not any([profile == "RuntimeDefault", profile == "Localhost"])

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.securityContext.seccompProfile.type=%s", [metadata.name, specInfo.path, profile]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.securityContext.seccompProfile.type should be set to 'RuntimeDefault' or 'Localhost'", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.securityContext.seccompProfile.type is set to '%s'", [metadata.name, specInfo.path, profile]),
	}
}

# neither pod nor container define seccompProfile.type
checkSeccompProfile(specInfo, container, containerType, document, metadata) = result {
	specCtx := object.get(specInfo.spec, "securityContext", {})
	specSeccompCtx := object.get(specCtx, "seccompProfile", {})
	not common_lib.valid_key(specSeccompCtx, "type")

	common_lib.valid_key(container, "securityContext")
	containerSeccompCtx := object.get(container.securityContext, "seccompProfile", {})
	not common_lib.valid_key(containerSeccompCtx, "type")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext", [metadata.name, specInfo.path, containerType, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type should be defined", [metadata.name, specInfo.path, containerType, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.seccompProfile.type is undefined", [metadata.name, specInfo.path, containerType, container.name]),
	}
}

# seccompProfile since Kubernetes v1.19
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	result := checkSeccompProfile(specInfo, specInfo.spec[types[x]][_], types[x], document, metadata)
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
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, seccompAnnotationPath]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s is 'runtime/default'", [metadata.name, seccompAnnotationPath]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s is '%s'", [metadata.name, seccompAnnotationPath, seccomp]),
	}
}
