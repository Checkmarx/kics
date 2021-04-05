package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Policy"
	checkPolicy(resource.Properties.PolicyDocument.Statement[_])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.PolicyDocument.Statement' doesn't contain '*'",
		"keyActualValue": "'Resources.Properties.PolicyDocument.Statement' contains '*'",
	}
}

checkPolicy(pol) {
	pol.Effect == "Allow"
	pol.Resource == "*"
	checkAction(pol.Action)
}

checkAction(act) {
	act == "*"
}

checkAction(act) {
	act[_] == "*"
}
