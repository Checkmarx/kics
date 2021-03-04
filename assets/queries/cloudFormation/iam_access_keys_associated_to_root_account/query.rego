package Cx

CxPolicy[result] {
	accessKey := input.document[i].Resources[name]
	accessKey.Type == "AWS::IAM::AccessKey"

	userRef := accessKey.Properties.UserName

	contains(lower(userRef), "root")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.UserName", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.UserName' is not asssociated to root account.", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.UserName' is asssociated to root account.", [name]),
	}
}
