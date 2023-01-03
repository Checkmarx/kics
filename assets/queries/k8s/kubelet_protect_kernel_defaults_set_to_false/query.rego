package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]

	common_lib.inArray(container.command, "kubelet")
	k8sLib.hasFlag(container, "--protect-kernel-defaults=false")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--protect-kernel-defaults flag should not be set to false",
		"keyActualValue": "--protect-kernel-defaults flag is set to false",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    not common_lib.valid_key(doc, "protectKernelDefaults")

	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "protectKernelDefaults flag should defined to true",
		"keyActualValue": "protectKernelDefaults flag is not defined",
	}
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    doc.protectKernelDefaults == false

	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}.protectKernelDefaults",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "protectKernelDefaults flag should defined to true",
		"keyActualValue": "protectKernelDefaults flag is set to false",
	}
}

