package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.aws_redshift_cluster[name]
	not common_lib.valid_key(cluster, "encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_redshift_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_redshift_cluster.encrypted is defined and not null",
		"keyActualValue": "aws_redshift_cluster.encrypted is undefined or null",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.aws_redshift_cluster[name]
	cluster.encrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_redshift_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("aws_redshift_cluster[%s].encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.encrypted is false",
		"keyActualValue": "aws_redshift_cluster.encrypted is true",
	}
}
