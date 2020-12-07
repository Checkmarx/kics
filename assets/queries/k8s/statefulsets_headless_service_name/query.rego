package Cx

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  specs := input.document[i].spec
  matchLabelsCheck := specs.selector.matchLabels
  lablesCheck := specs.template.metadata.labels
  matchLabelsCheck != lablesCheck
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.selector.matchLabels", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.selector.matchLabels match with template.metadata.labels", [metadata.name]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.selector.matchLabels doesn't match with template.metadata.labels", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  specs := input.document[i].spec
  clusterIP := specs.clusterIP
  clusterIP != "None"
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.clusterIP", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.clusterIP creates a Headless Service", [metadata.name]),
                "keyActualValue": 	sprintf("metadata.name=%s.clusterIP doesn't creates a Headless Service", [metadata.name]),
              }
}