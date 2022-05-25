package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob", "PersistentVolumeClaim"]

CxPolicy[result] {
	document := input.document[i]
	k8sLib.checkKind(document.kind, listKinds)
	metadata := document.metadata

	namespace := object.get(metadata, "namespace", "default")

	resourceQuota := [doc | doc := input.document[_]; doc.kind == "ResourceQuota"; matchNamespace(doc, namespace)]
	count(resourceQuota) == 0

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"keyExpectedValue": sprintf("metadata.name={{%s}} has a 'ResourceQuota' policy associated", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}} does not have a 'ResourceQuota' policy associated", [metadata.name]),
		"searchLine": common_lib.build_search_line(["metadata", "namespace"], [])
	}
}

matchNamespace(document, namespace) {
	document.metadata.namespace == namespace
} else {
	namespace == "default"
	not common_lib.valid_key(document.metadata, "namespace")
}
