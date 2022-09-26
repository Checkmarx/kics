package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-apiserver")
	not k8sLib.hasFlagWithValue(container, "--enable-admission-plugins", "PodSecurityPolicy")
	not k8sLib.hasFlagWithValue(container, "--enable-admission-plugins", "SecurityContextDeny")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "--enable-admission-plugins flag should contain 'SecurityContextDeny' plugin if 'PodSecurityPolicy' plugin should not be set",
		"keyActualValue": "--enable-admission-plugins flag does not contain 'SecurityContextDeny' plugin",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}

