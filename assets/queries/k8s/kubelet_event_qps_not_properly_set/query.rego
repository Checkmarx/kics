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
	k8sLib.startWithFlag(container,"--event-qps")
	not k8sLib.hasFlag(container, "--event-qps=0")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--event-qps flag should be set to 0",
		"keyActualValue": "--event-qps flag is not set to 0",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    not common_lib.valid_key(doc, "eventRecordQPS")

	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "eventRecordQPS flag should set to 0",
		"keyActualValue": "eventRecordQPS flag is not defined",
	}
}

CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    doc.eventRecordQPS != 0

	result := {
		"documentId": doc.id,
		"resourceType": doc.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}.eventRecordQPS",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "eventRecordQPS flag should set to 0",
		"keyActualValue": "eventRecordQPS flag is not set to 0",
	}
}

