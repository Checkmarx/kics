package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_access_key[name]
	contains(lower(resource.user), "root")
	object.get(resource, "status", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_access_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_iam_access_key[%s].status' is defined and set to 'Inactive'", [name]),
		"keyActualValue": sprintf("'aws_iam_access_key[%s].status' is undefined, that defaults to 'Active'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_access_key[name]
	contains(lower(resource.user), "root")
	resource.status == "Active"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_access_key[%s].status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_iam_access_key[%s].status' is defined and set to 'Inactive'", [name]),
		"keyActualValue": sprintf("'aws_iam_access_key[%s].status' is set to 'Active'", [name]),
	}
}
