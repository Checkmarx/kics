package Cx

CxPolicy [result ] {

  statefulset := input.document[i]
  statefulset.kind == "StatefulSet"
  metadata := statefulset.metadata

  not CheckIFPdbExists(statefulset)

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s", [metadata.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("metadata.name=%s is not targeted by a PDB", [metadata.name]),
                "keyActualValue": 	sprintf("metadata.name=%s is not targeted by a PDB", [metadata.name])
            }
}

CheckIFPdbExists (statefulsets) = result{

	documents := input.document
	pdbs := [pdb | documents[index].kind == "PodDisruptionBudget"; pdb = documents[index]]

  result := contains(pdbs, statefulsets.spec.selector.matchLabels.app)

}

contains (array, string) = true {
	array[a].spec.selector.matchLabels.app == string
}
