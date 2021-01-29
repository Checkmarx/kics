package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.publicly_accessible

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].publicly_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_db_instance[%s].publicly_accessible' is false", [name]),
		"keyActualValue": sprintf("'aws_db_instance[%s].publicly_accessible' is true", [name]),
	}
}
