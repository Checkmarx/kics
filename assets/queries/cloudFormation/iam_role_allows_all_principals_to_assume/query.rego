package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].Resources[Name]
	resource.Type == "AWS::IAM::Role"

	out := commonLib.json_unmarshal(resource.Properties.AssumeRolePolicyDocument)
	aws := out.Statement[_].Principal.AWS

	commonLib.allowsAllPrincipalsToAssume(aws, out.Statement[_])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement.Principal.AWS", [Name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement.Principal.AWS does not contain ':root'", [Name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement.Principal.AWS contains ':root'", [Name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[Name]
	resource.Type == "AWS::IAM::Role"

	statement := resource.Properties.AssumeRolePolicyDocument.Statement[_]
	aws := statement.Principal.AWS

	commonLib.allowsAllPrincipalsToAssume(aws, statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement.Principal.AWS", [Name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement.Principal.AWS does not contain ':root'", [Name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement.Principal.AWS contains ':root'", [Name]),
	}
}
