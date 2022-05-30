package Cx

CxPolicy[result] {
	statefulset := input.document[i]
	statefulset.kind == "StatefulSet"
	statefulset.spec.replicas > 1
	metadata := statefulset.metadata

	hasPodDisruptionBudget(statefulset) == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": statefulset.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector.matchLabels", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s is targeted by a PodDisruptionBudget", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s is not targeted by a PodDisruptionBudget", [metadata.name]),
	}
}

hasPodDisruptionBudget(statefulset) = result {
	pdb := input.document[j]
	pdb.kind == "PodDisruptionBudget"
	result := containsLabel(pdb, statefulset.spec.selector.matchLabels)
} else = false {
	true
}

containsLabel(array, label) {
	array.spec.selector.matchLabels[_] == label[_]
}
