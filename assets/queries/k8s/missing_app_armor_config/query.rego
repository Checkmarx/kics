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

# Valid types for the new securityContext.appArmorProfile API (Kubernetes 1.23+).
# "Unconfined" is not a valid type as stated in the documentation.
validAppArmorProfileType(t) {
	t == "RuntimeDefault"
} else {
	t == "Localhost"
}

# True when the container has valid AppArmor via securityContext.appArmorProfile
hasValidAppArmorProfileNewSyntax(document, typeKey, containerIndex) {
	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[typeKey][containerIndex]
	containerAppArmor := object.get(object.get(container, "securityContext", {}), "appArmorProfile", {})
	containerAppArmor.type != null
	validAppArmorProfileType(containerAppArmor.type)
}

# True when the pod has valid AppArmor via securityContext.appArmorProfile
hasValidAppArmorProfileNewSyntax(document, typeKey, containerIndex) {
	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[typeKey][containerIndex]
	containerAppArmor := object.get(object.get(container, "securityContext", {}), "appArmorProfile", {})
	not containerAppArmor.type
	podAppArmor := object.get(object.get(specInfo.spec, "securityContext", {}), "appArmorProfile", {})
	podAppArmor.type != null
	validAppArmorProfileType(podAppArmor.type)
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c].name

	metadataInfo := getMetadataInfo(document)
	annotations := object.get(metadataInfo.metadata, "annotations", {})
	expectedKey := sprintf("container.apparmor.security.beta.kubernetes.io/%s", [container])

	not isValidAppArmorProfile(annotations[expectedKey])
	not hasValidAppArmorProfileNewSyntax(document, x, c)

	annotationsPath := trim_left(sprintf("%s.annotations", [metadataInfo.path]), ".")
	searchPath := get_apparmor_search_path(specInfo, x, c, annotationsPath)
	msg := get_apparmor_messages(searchPath, metadata.name, container, "IncorrectValue", expectedKey, annotationsPath)
	searchValue := get_apparmor_search_value(searchPath, document.kind, expectedKey, x, c, "IncorrectValue")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, searchPath]),
		"issueType": "IncorrectValue",
		"searchValue": searchValue,
		"keyExpectedValue": msg.keyExpectedValue,
		"keyActualValue": msg.keyActualValue,
		"searchLine": build_search_line_for_apparmor(searchPath),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c].name

	metadataInfo := getMetadataInfo(document)
	annotations := object.get(metadataInfo.metadata, "annotations", {})
	expectedKey := sprintf("container.apparmor.security.beta.kubernetes.io/%s", [container])

	not common_lib.valid_key(annotations, expectedKey)
	not hasValidAppArmorProfileNewSyntax(document, x, c)

	annotationsPath := trim_left(sprintf("%s.annotations", [metadataInfo.path]), ".")
	searchPath := get_apparmor_search_path(specInfo, x, c, annotationsPath)
	msg := get_apparmor_messages(searchPath, metadata.name, container, "MissingAttribute", expectedKey, annotationsPath)
	searchValue := get_apparmor_search_value(searchPath, document.kind, expectedKey, x, c, "MissingAttribute")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, searchPath]),
		"issueType": "MissingAttribute",
		"searchValue": searchValue,
		"keyExpectedValue": msg.keyExpectedValue,
		"keyActualValue": msg.keyActualValue,
		"searchLine": build_search_line_for_apparmor(searchPath),
	}
}

# searchValue for similarity ID / result identity: use path when new syntax, else annotation-style value.
get_apparmor_search_value(searchPath, kind, expectedKey, typeKey, containerIndex, issueType) = v {
	contains(searchPath, "securityContext")
	v := sprintf("%s.%s", [kind, searchPath])
} else = v {
	issueType == "IncorrectValue"
	v := sprintf("%s%s", [kind, expectedKey])
} else = v {
	v := sprintf("%s%s%d", [kind, typeKey, containerIndex])
}

# Returns keyExpectedValue and keyActualValue aligned with the path we point to (annotations vs securityContext).
get_apparmor_messages(searchPath, metadataName, container, issueType, expectedKey, annotationsPath) = msg {
	contains(searchPath, "securityContext")
	issueType == "MissingAttribute"
	msg := {
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s should specify an AppArmor profile (e.g. appArmorProfile.type: RuntimeDefault or Localhost) for container {{%s}}", [metadataName, searchPath, container]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s does not specify an AppArmor profile for container {{%s}}", [metadataName, searchPath, container]),
	}
} else = msg {
	contains(searchPath, "securityContext")
	issueType == "IncorrectValue"
	msg := {
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.type should be set to 'RuntimeDefault' or 'Localhost'", [metadataName, searchPath]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.type does not specify a valid AppArmor profile (Unconfined is not accepted)", [metadataName, searchPath]),
	}
} else = msg {
	issueType == "MissingAttribute"
	msg := {
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s should specify an AppArmor profile for container {{%s}}", [metadataName, annotationsPath, container]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s does not specify an AppArmor profile for container {{%s}}", [metadataName, annotationsPath, container]),
	}
} else = msg {
	msg := {
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s[%s] should be set to 'runtime/default' or 'localhost'", [metadataName, annotationsPath, expectedKey]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s[%s] does not specify a valid AppArmor profile", [metadataName, annotationsPath, expectedKey]),
	}
}

# build search path for apparmor profile
get_apparmor_search_path(specInfo, typeKey, containerIndex, annotationsPath) = path {
	container := specInfo.spec[typeKey][containerIndex]
	common_lib.valid_key(container, "securityContext")
	common_lib.valid_key(object.get(container, "securityContext", {}), "appArmorProfile")
	path := sprintf("%s.%s.%d.securityContext.appArmorProfile", [specInfo.path, typeKey, containerIndex])
} else = path {
	container := specInfo.spec[typeKey][containerIndex]
	common_lib.valid_key(container, "securityContext")
	path := sprintf("%s.%s.%d.securityContext", [specInfo.path, typeKey, containerIndex])
} else = path {
	common_lib.valid_key(specInfo.spec, "securityContext")
	common_lib.valid_key(object.get(specInfo.spec, "securityContext", {}), "appArmorProfile")
	path := sprintf("%s.securityContext.appArmorProfile", [specInfo.path])
} else = path {
	common_lib.valid_key(specInfo.spec, "securityContext")
	path := sprintf("%s.securityContext", [specInfo.path])
} else = path {
	path := annotationsPath
}

# Builds search line for either annotation path (old syntax) or spec path (new syntax).
build_search_line_for_apparmor(path) = searchLine {
	path == "annotations"
	searchLine := common_lib.build_search_line(["metadata", "annotations"], [])
} else = searchLine {
	contains(path, "securityContext")
	searchLine := common_lib.build_search_line(split(path, "."), [])
} else = searchLine {
	searchLine := common_lib.build_search_line(split(path, "."), [])
}
