package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SNS::TopicPolicy"
	document := resource.Properties.PolicyDocument
	statements = document.Statement
	statements[k].Effect == "Allow"
	common_lib.valid_key(statements[k], "NotAction")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Sid=%s", [name, statements[k].Sid]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Sid[%s] has Effect 'Allow' and Action", [name, statements[k].Sid]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Sid[%s] has Effect 'Allow' and NotAction", [name, statements[k].Sid]),
	}
}
