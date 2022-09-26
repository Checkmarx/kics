package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	members := input.document[i].resource.google_project_iam_binding[name].members
	mail := members[_]

	contains(mail, "gmail.com")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_binding",
		"resourceName": tf_lib.get_resource_name(members, name),
		"searchKey": sprintf("google_project_iam_binding[%s].members.%s", [name, mail]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'members' cannot contain Gmail account addresses",
		"keyActualValue": sprintf("'members' has email address: %s", [mail]),
	}
}
