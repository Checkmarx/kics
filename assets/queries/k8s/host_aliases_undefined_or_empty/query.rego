package Cx

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  object.get(spec, "hostAliases", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec", [metadata.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.hostAliases is defined", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.hostAliases is undefined", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  spec.hostAliases == null

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.hostAliases", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.hostAliases is not null", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.hostAliases is null", [metadata.name])
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  checkAction(spec.hostAliases)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.hostAliases", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  sprintf("metadata.name=%s.spec.hostAliases is not empty", [metadata.name]),
                "keyActualValue": 	 sprintf("metadata.name=%s.spec.hostAliases is empty", [metadata.name])
              }
}

checkAction(action) = true {
	is_array(action)
	count(action) == 0
}