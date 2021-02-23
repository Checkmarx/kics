package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_ebs_snapshot[name]
	object.get(resource,"encrypted","undefined") != "undefined"
	not resource.encrypted

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ebs_snapshot[%s].encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_ebs_snapshot.encrypted' is true",
		"keyActualValue": "'aws_ebs_snapshot.encrypted' is false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ebs_snapshot[name]
	object.get(resource,"encrypted","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ebs_snapshot[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_ebs_snapshot.encrypted' is set",
		"keyActualValue": "'aws_ebs_snapshot.encrypted' is undefined",
	}
}
