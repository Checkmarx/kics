package Cx

CxPolicy [ result ] {
   resource := input.document[i].resource.aws_kms_key[name]
   policy_exists := object.get(resource, "policy", "undefined") != "undefined"
   policy := json_unserialize(resource.policy)
   
   statement = policy.Statement[_]
   check_permission(statement) == true
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_kms_key[%s].policy", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("aws_kms_key[%s].policy definition is correct", [name]),
                "keyActualValue": 	sprintf("aws_kms_key[%s].policy definition is incorrect", [name])
              }
}

json_unserialize(policy) = result {
	policy != null
	result := json.unmarshal(policy)
}

check_permission(statement) = true {
    statement.Principal.AWS == "*"
    statement.Action[_] == "kms:*"
    statement.Resource == "*"
}