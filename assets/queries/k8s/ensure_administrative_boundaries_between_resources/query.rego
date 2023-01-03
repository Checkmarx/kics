package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob", "Service", "Secret", "ServiceAccount", "Role", "RoleBinding", "ConfigMap", "Ingress"]

CxPolicy[result] {
    nsSearch := [nsSearch |res = input.document[_];
					res.kind == listKinds[_]; 
					nspace := res.metadata.namespace;
                    nsSearch := {"namespace": nspace,"res": res.id, "name": res.metadata.name, "kind": res.kind}]

    namespaces := {ns | ns:=nsSearch[_].namespace }
    namespacesContac:= concat(", ",namespaces)

	result := {
		"documentId": nsSearch[0].res,
		"resourceType": nsSearch[0].kind,
		"resourceName": nsSearch[0].name,
		"searchKey": sprintf("metadata.namespace={{%s}}", [nsSearch[0].namespace]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ensure that these namespaces are the ones you need and are adequately administered as per your requirements.",
		"keyActualValue": sprintf("namespaces in use: %s", [namespacesContac]),
		"searchLine": common_lib.build_search_line(["metadata", "namespace"], []),
	}
}
