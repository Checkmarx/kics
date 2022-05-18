package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob", "Service", "Secret", "ServiceAccount", "Role", "RoleBinding", "ConfigMap", "Ingress"]

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata

    resource.kind == listKinds[_]
    namespace := metadata.namespace

    c := count({j | res = input.document[j]; res.kind == listKinds[_]; res.metadata.namespace == namespace})
    c > 1

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.namespace={{%s}}", [metadata.namespace]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "consider using diffrent namespace",
		"keyActualValue": "same namaspace is used used multiple times",
		"searchLine": common_lib.build_search_line(["metadata", "namespace"], []),
	}
}
