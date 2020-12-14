package Cx

CxPolicy [result] {
    document := input.document[i]
    metadata := document.metadata
    
    validKind := ["Role","ClusterRole"]
    ruleTaint := ["get","watch","list","*"]
    resourcesTaint := ["secrets"]
    
    kind := document.kind
    contains(validKind,kind)
    name := metadata.name
    
    bindingExists(name,kind)
    
   	resources := document.rules[_].resources; 
    some resource
    	contains(resourcesTaint,resources[resource])
    
    rules := document.rules[_].verbs;    
    some rule
    	contains(ruleTaint,rules[rule])
    
    result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("metadata.name=%s.rules.verbs", [metadata.name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue":  sprintf("The %s.rules.verbs should not contain the following verbs: [%s]", [metadata.name,rules]),
                "keyActualValue":    sprintf("The %s.rules.verbs contain the following verbs: [%s]", [metadata.name,rules])
              }
}

contains(arr1,string) = true{
	arr1[_] == string
}

bindingExists(name,kind) = true{
	
    kind == "Role"
    
	some roleBinding
    	input.document[roleBinding].kind == "RoleBinding"
        input.document[roleBinding].subjects[_].kind == "ServiceAccount"
        input.document[roleBinding].roleRef.kind == "Role"
        input.document[roleBinding].roleRef.name == name              
} else = true{
	
    kind == "ClusterRole"
    
	some roleBinding
    	input.document[roleBinding].kind == "ClusterRoleBinding"
        input.document[roleBinding].subjects[_].kind == "ServiceAccount"
        input.document[roleBinding].roleRef.kind == "ClusterRole"
        input.document[roleBinding].roleRef.name == name
}