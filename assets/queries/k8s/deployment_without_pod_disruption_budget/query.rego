package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	deployment := input.document[i]
	deployment.kind == "Deployment"
	deployment.spec.replicas > 1
	metadata := deployment.metadata

	k8sLib.CheckIFPdbExists(deployment) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector.matchLabels", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s is targeted by a PodDisruptionBudget", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s is not targeted by a PodDisruptionBudget", [metadata.name]),
	}
}
