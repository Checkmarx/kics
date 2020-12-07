package Cx

CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    document.kind == "ClusterRole"
    metadata.name
    notExpectedKey := "*"
    rules := document.rules[_]
    rules.apiGroups[j] == notExpectedKey
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.apiGroups", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.apiGroups shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.apiGroups contain value: '%s'", [metadata.name, notExpectedKey])
              }

}

CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    document.kind == "ClusterRole"
    metadata.name
    notExpectedKey := "*"
    document.rules[_].resources[j] == notExpectedKey
    
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.resources", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.resources shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.resources contain value: '%s'", [metadata.name, notExpectedKey])
              }

}

CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    document.kind == "ClusterRole"
    metadata.name
    notExpectedKey := "*"
    document.rules[_].verbs[j] == notExpectedKey
    
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.verbs", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.verbs shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.verbs contain value: '%s'", [metadata.name, notExpectedKey])
              }
}
CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    document.kind == "Role"
    metadata.name
    notExpectedKey := "*"
    document.rules[_].verbs[j] == notExpectedKey
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.verbs", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.verbs shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.verbs contain value: '%s'", [metadata.name, notExpectedKey])
              }
}
CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    document.kind == "Role"
    metadata.name
    notExpectedKey := "*"
    document.rules[_].resources[j] == notExpectedKey
    
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.resources", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.resources shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.resources contain value: '%s'", [metadata.name, notExpectedKey])
              }

}
CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    document.kind == "Role"
    metadata.name
    notExpectedKey := "*"
    document.rules[_].apiGroups[j] == notExpectedKey
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.apiGroups", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.apiGroups shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.apiGroups contain value: '%s'", [metadata.name, notExpectedKey])
              }

}