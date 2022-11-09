package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

knativeKinds := ["Configuration", "Service", "Revision", "ContainerSource"]
listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob" ]

CxPolicy[result] {
	document := input.document[i]
	k8sLib.checkKindWithKnative(document, listKinds, knativeKinds)
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	result := checkAutomount(specInfo, document, metadata)
}

CxPolicy[result] {
	document := input.document[i]
	k8sLib.checkKindWithKnative(document, listKinds, knativeKinds)
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	not common_lib.valid_key(specInfo.spec, "automountServiceAccountToken")

	serviceAccountName := object.get(specInfo.spec, "serviceAccountName", "default")
	SAWithAutoMount := [x |
		res := input.document[_]
		res.kind == "ServiceAccount"
		res.metadata.name == serviceAccountName
		common_lib.valid_key(res, "automountServiceAccountToken")
		x := res
	]

	count(SAWithAutoMount) == 0

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, specInfo.path]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.automountServiceAccountToken should be defined and set to false", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.automountServiceAccountToken is undefined", [metadata.name, specInfo.path]),
	}
}

# If automountServiceAccountToken is defined at pod level, it takes precedence over a SA definition
checkAutomount(specInfo, document, metadata) = result {
	specInfo.spec.automountServiceAccountToken == true

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.automountServiceAccountToken", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.automountServiceAccountToken should be set to false", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.automountServiceAccountToken is true", [metadata.name, specInfo.path]),
	}
}

checkAutomount(specInfo, document, metadata) = result {
	not common_lib.valid_key(specInfo.spec, "automountServiceAccountToken")
	serviceAccountName := object.get(specInfo.spec, "serviceAccountName", "default")

	SAWithAutoMount := [x |
		res := input.document[_]
		res.kind == "ServiceAccount"
		res.metadata.name == serviceAccountName
		res.automountServiceAccountToken == true
		x := res
	]

	count(SAWithAutoMount) > 0

	result := {
		"documentId": SAWithAutoMount[k].id,
		"resourceType": SAWithAutoMount[k].kind,
		"resourceName": SAWithAutoMount[k].metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.automountServiceAccountToken", [SAWithAutoMount[k].metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.automountServiceAccountToken should be set to false", [SAWithAutoMount[k].metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.automountServiceAccountToken is true", [SAWithAutoMount[k].metadata.name]),
	}
}
