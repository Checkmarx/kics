package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Type == "AWS::KMS::Key"
	policy := resources.Properties.KeyPolicy
	statement := policy.Statement[_]

	statement.Principal.AWS == "*"
	commonLib.equalsOrInArray(statement.Action, "kms:*")
	statement.Resource == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.KeyPolicy.Statement.Sid=%s", [name, statement.Sid]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Sid[%s] is correct", [name, statement.Sid]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Sid[%s] is too exposed", [name, statement.Sid]),
	}
}
