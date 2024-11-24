package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_redshift_cluster[name]

	attributes := {"vpc_security_group_ids", "cluster_subnet_group_name"}
	some attr in attributes

	not common_lib.valid_key(resource, attr)

	result := {
		"documentId": document.id,
		"resourceType": "aws_redshift_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_redshift_cluster[%s].%s should be set", [name, attr]),
		"keyActualValue": sprintf("aws_redshift_cluster[%s].%s is undefined", [name, attr]),
		"searchValue": sprintf("%s", [attr]),
	}
}
