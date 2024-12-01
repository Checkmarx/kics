package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	accessKey := document.Resources[name]
	accessKey.Type == "AWS::IAM::AccessKey"

	userRef := accessKey.Properties.UserName

	contains(lower(userRef), "root")

	result := {
		"documentId": document.id,
		"resourceType": accessKey.Type,
		"resourceName": cf_lib.get_resource_name(accessKey, name),
		"searchKey": sprintf("Resources.%s.Properties.UserName", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.UserName' should not be asssociated to root account.", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.UserName' is asssociated to root account.", [name]),
	}
}
