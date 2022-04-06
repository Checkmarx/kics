package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "ClusterRole"
	verbs := resource.rules[j].verbs
	verbs[y] == "create"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kind={{ClusterRole}}.rules",[]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "create priveleges should not be attributed  to the cluster role",
		"keyActualValue": "Create priveleges are attributed the cluster role",
	}
}
