package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	object.get(resource, "description", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[{{%s}}] description is defined", [name]),
		"keyActualValue": sprintf("aws_security_group[{{%s}}] description is missing", [name]),
	}
}
