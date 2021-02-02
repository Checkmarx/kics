package Cx

CxPolicy[result] {
	deployment := input.document[i]
	deployment.kind == "Deployment"
	deployment.spec.replicas > 1
	metadata := deployment.metadata

	CheckIFPdbExists(deployment) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector.matchLabels", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s is targeted by a PodDisruptionBudget", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s is not targeted by a PodDisruptionBudget", [metadata.name]),
	}
}

CheckIFPdbExists(deployments) = result {
	documents := input.document
	pdbs := [pdb | documents[index].kind == "PodDisruptionBudget"; pdb = documents[index]]
	result := contains(pdbs, deployments.spec.selector.matchLabels)
} else = false {
	true
}

contains(array, label) {
	array[a].spec.selector.matchLabels[_] == label[_]
}
