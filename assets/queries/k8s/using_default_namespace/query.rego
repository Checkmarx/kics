package Cx

listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob", "Service", "Secret", "ServiceAccount", "Role", "RoleBinding", "ConfigMap", "Ingress"]

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]

	kind := document.kind
	k8sLib.checkKind(kind, listKinds)

	metadata = document.metadata

	not common_lib.valid_key(metadata, "namespace")

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("kind={{%s}}.metadata.name={{%s}}", [kind, metadata.name]),
		"keyExpectedValue": "metadata.namespace is set",
		"keyActualValue": "metadata.namespace is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]

	kind := document.kind
	k8sLib.checkKind(kind, listKinds)

	metadata = document.metadata
	metadata.namespace == "default"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("kind={{%s}}.metadata.name={{%s}}", [kind, metadata.name]),
		"keyExpectedValue": "metadata.namespace is not default",
		"keyActualValue": "metadata.namespace is default",
	}
}
