package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	launch_permissions := input.document[i].resource.aws_ami_launch_permission

	account_id := launch_permissions[name].account_id
	image_id := launch_permissions[name].image_id

	count([account | launch_permissions[j].image_id == image_id; account := launch_permissions[j].account_id]) > 1

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ami_launch_permission",
		"resourceName": tf_lib.get_resource_name(launch_permissions[name], name),
		"searchKey": sprintf("aws_ami_launch_permission[%s].image_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ami_launch_permission[%s].image_id' should not be shared with multiple accounts", [name]),
		"keyActualValue": sprintf("'aws_ami_launch_permission[%s].image_id' is shared with multiple accounts", [name]),
	}
}
