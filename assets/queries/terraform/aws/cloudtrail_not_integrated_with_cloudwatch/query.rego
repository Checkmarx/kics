package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	cloudtrail := document.resource.aws_cloudtrail[name]
	attr := {"cloud_watch_logs_role_arn", "cloud_watch_logs_group_arn"}
	attribute := attr[a]

	not common_lib.valid_key(cloudtrail, attribute)

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(cloudtrail, name),
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].%s should be defined and not null", [name, attribute]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].%s is undefined or null", [name, attribute]),
	}
}
