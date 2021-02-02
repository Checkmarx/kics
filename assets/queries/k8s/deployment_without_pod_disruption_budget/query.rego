package Cx

CxPolicy[result] {
	deployment := input.document[i]
	deployment.kind == "Deployment"
	deployment.spec.replicas > 1
	metadata := deployment.metadata

	not CheckIFPdbExists(deployment)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector.matchLabels", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s is targeted by a PDB", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s is not targeted by a PDB", [metadata.name]),
	}
}

CheckIFPdbExists(deployments) = result {
	documents := input.document
	pdbs := [pdb | documents[index].kind == "PodDisruptionBudget"; pdb = documents[index]]

	result := contains(pdbs, deployments.spec.selector.matchLabels)
}

contains(array, label) {
	array[a].spec.selector.matchLabels[_] == label[_]
}
