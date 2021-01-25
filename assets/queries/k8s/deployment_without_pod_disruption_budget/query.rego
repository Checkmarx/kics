package Cx

CxPolicy[result] {
	deployment := input.document[i]
	deployment.kind == "Deployment"
	metadata := deployment.metadata

	not CheckIFPdbExists(deployment)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s are targeted by a PDB", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s are not targeted by a PDB", [metadata.name]),
	}
}

CheckIFPdbExists(deployments) = result {
	documents := input.document
	pdbs := [pdb | documents[index].kind == "PodDisruptionBudget"; pdb = documents[index]]

	result := contains(pdbs, deployments.spec.selector.matchLabels.app)
}

contains(array, string) {
	array[a].spec.selector.matchLabels.app == string
}
