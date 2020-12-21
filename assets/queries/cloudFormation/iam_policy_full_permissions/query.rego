package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::IAM::Policy"

  statements := resource.PolicyDocument.Statement
  checkPolicy(statements[i])

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.PolicyDocument.Statement.Resource=%s", [name,statements[i].Resource]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("'Resources.%s.PolicyDocument.Statement.Resource=%s' does not have full permissions or is Admin",[name,statements[i].Resource]),
                "keyActualValue": 	sprintf("'Resources.%s.PolicyDocument.Statement.Resource=%s' has full permissions and is not Admin.",[name,statements[i].Resource])
              }
}

checkPolicy(pol) {
    pol.Effect == "Allow"
    pol.Resource != "arn:aws:iam::aws:policy/AdministratorAccess"
    checkAction(pol.Action)
}

checkAction(act) {
	act == "*"
}

checkAction(act) {
	act[_] == "*"
}