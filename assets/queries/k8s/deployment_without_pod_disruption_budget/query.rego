package Cx

import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some deployment in input.document
	deployment.kind == "Deployment"
	deployment.spec.replicas > 1
	metadata := deployment.metadata

	hasPodDisruptionBudget(deployment) == false

	result := {
		"documentId": deployment.id,
		"resourceType": deployment.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector.matchLabels", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s is targeted by a PodDisruptionBudget", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s is not targeted by a PodDisruptionBudget", [metadata.name]),
	}
}

hasPodDisruptionBudget(statefulset) = result {
	some pdb in input.document
	pdb.kind == "PodDisruptionBudget"
	result := containsLabel(pdb, statefulset.spec.selector.matchLabels)
} else = false

containsLabel(array, label) {
	array.spec.selector.matchLabels[_] == label[_]
}
