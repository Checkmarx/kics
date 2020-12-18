package Cx

CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    checkKind(document.kind)
    metadata.name
    notExpectedKey := "*"
    rules := document.rules[_]
    rules.apiGroups[j] == notExpectedKey
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.apiGroups", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.apiGroups shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.apiGroups contains value: '%s'", [metadata.name, notExpectedKey])
              }

}

CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    checkKind(document.kind)
    metadata.name
    notExpectedKey := "*"
    document.rules[_].resources[j] == notExpectedKey
    
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.resources", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.resources shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.resources contains value: '%s'", [metadata.name, notExpectedKey])
              }

}

CxPolicy [result]  {
	document := input.document[i]
    metadata := document.metadata
    checkKind(document.kind)
    metadata.name
    notExpectedKey := "*"
    document.rules[_].verbs[j] == notExpectedKey
    
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.rules.verbs", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name[%s].rules.verbs shouldn't contain value: '%s'", [metadata.name, notExpectedKey]),
                "keyActualValue": 	sprintf("metadata.name[%s].rules.verbs contains value: '%s'", [metadata.name, notExpectedKey])
              }
}

checkKind(kind) = true{
kind == "Role"
}

checkKind(kind) = true{
kind == "ClusterRole"
}
