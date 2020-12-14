package Cx

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  input.document[i].kind == "Service"
  specs := input.document[i].spec
  specs.clusterIP != "None"
  some j
  input.document[j].kind == "StatefulSet"
  input.document[j].spec.selector.matchLabels == input.document[j].spec.template.metadata.labels

  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.clusterIP", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.clusterIP creates a Headless Service", [metadata.name]),
                "keyActualValue": 	sprintf("metadata.name=%s.clusterIP doesn't creates a Headless Service", [metadata.name]),
              }
}