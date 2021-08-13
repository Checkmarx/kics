package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_access_key[name]

	user := split(resource.user, ".")[1]

	count({x | r := input.document[_].resource.aws_iam_access_key[x]; split(r.user, ".")[1] == user}) > 1

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_access_key[%s].user", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One Access Key associated with the same IAM User",
		"keyActualValue": "More than one Access Key associated with the same IAM User",
	}
}
