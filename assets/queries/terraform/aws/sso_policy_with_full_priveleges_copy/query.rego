package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_identitystore_user[name]

	result := {
		"documentId": doc.id,
		"resourceType": "aws_identitystore_user",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_identitystore_user[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_identitystore_user resource should not be used",
		"keyActualValue": "aws_identitystore_user resource is used",
		"searchLine": common_lib.build_search_line(["resource", "aws_identitystore_user", name], []),
	}
}
