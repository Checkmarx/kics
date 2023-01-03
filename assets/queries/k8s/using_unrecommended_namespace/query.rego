package Cx

listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob", "Service", "Secret", "ServiceAccount", "Role", "RoleBinding", "ConfigMap", "Ingress", "Configuration", "Service", "Revision", "ContainerSource"]

import data.generic.common as common_lib
import data.generic.k8s as k8s_lib

CxPolicy[result] {
	document := input.document[i]

	kind := document.kind
	k8s_lib.checkKind(kind, listKinds)

	metadata = document.metadata

	not common_lib.valid_key(metadata, "namespace")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("kind={{%s}}.metadata.name={{%s}}", [kind, metadata.name]),
		"keyExpectedValue": "metadata.namespace should be defined and not null",
		"keyActualValue": "metadata.namespace is undefined or null",
		"searchLine": common_lib.build_search_line(["metadata", "name"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]

	kind := document.kind
	k8s_lib.checkKind(kind, listKinds)

	metadata = document.metadata

	options := {"default", "kube-system", "kube-public"}
	metadata.namespace == options[x]

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.namespace", [metadata.name]),
		"keyExpectedValue": "'metadata.namespace' should not be set to default, kube-system or kube-public",
		"keyActualValue": sprintf("'metadata.namespace' is set to %s", [options[x]]),
		"searchLine": common_lib.build_search_line(["metadata", "namespace"], []),
	}
}
