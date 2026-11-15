package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

valid_types := {"RuntimeDefault", "Localhost"}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]

	not has_valid_seccomp(container, specInfo.spec)

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Container '%s' should have seccompProfile.type set to 'RuntimeDefault' or 'Localhost'", [container.name]),
		"keyActualValue": sprintf("Container '%s' does not have a valid seccompProfile configured", [container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "securityContext"]),
	}
}

# seccomp defined at container level
has_valid_seccomp(container, _) {
	container.securityContext.seccompProfile.type == valid_types[_]
}

# seccomp defined at pod spec level
has_valid_seccomp(_, spec) {
	spec.securityContext.seccompProfile.type == valid_types[_]
}
