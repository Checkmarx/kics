package Cx

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  input.document[i].kind == "Service"
  specs := input.document[i].spec
  specs.clusterIP != "None"
  some j
  input.document[j].kind == "StatefulSet"
  input.document[j].spec.selector.matchLabels == input.document[j].spec.template.metadata.labels
  metadata.name == input.document[j].spec.serviceName

  
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("metadata.name=%s.spec.serviceName", [metadata.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.serviceName refers to a Headless Service", [metadata.name]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.serviceName doesn't refers to a Headless Service", [metadata.name]),
              }
}