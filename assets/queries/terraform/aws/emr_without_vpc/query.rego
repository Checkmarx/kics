package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_emr_cluster[name]

	attrs := {"subnet_id", "subnet_ids"}

	count({x | attr := attrs[x]; common_lib.valid_key(resource, attr)}) == 0

	result := {
		"documentId": document.id,
		"resourceType": "aws_emr_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_emr_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_emr_cluster[%s].subnet_id' or 'aws_emr_cluster[%s].subnet_ids' should be defined and not null'", [name, name]),
		"keyActualValue": sprintf("'aws_emr_cluster[%s].subnet_id' or 'aws_emr_cluster[%s].subnet_ids' is undefined or null", [name, name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_emr_cluster", name], []),
	}
}
