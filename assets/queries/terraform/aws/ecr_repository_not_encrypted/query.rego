package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]

	object.get(resource, "encryption_configuration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'encryption_configuration' is set",
		"keyActualValue": "The attribute 'encryption_configuration' is undefined",
	}
}
