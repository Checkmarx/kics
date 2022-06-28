package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_redshift_cluster[name]
	resource.logging.enable == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_redshift_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_redshift_cluster[%s].logging", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_redshift_cluster.logging' is true",
		"keyActualValue": "'aws_redshift_cluster.logging' is false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_redshift_cluster[name]
	not common_lib.valid_key(resource, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_redshift_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_redshift_cluster.logging' is true",
		"keyActualValue": "'aws_redshift_cluster.logging' is undefined",
	}
}
