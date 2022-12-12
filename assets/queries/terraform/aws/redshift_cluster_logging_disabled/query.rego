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
		"searchKey": sprintf("aws_redshift_cluster[%s].logging.enable", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_redshift_cluster", name, "logging", "enable"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_redshift_cluster.logging' should be true",
		"keyActualValue": "'aws_redshift_cluster.logging' is false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
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
		"searchLine": common_lib.build_search_line(["resource", "aws_redshift_cluster", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_redshift_cluster.logging' should be true",
		"keyActualValue": "'aws_redshift_cluster.logging' is undefined",
		"remediation": "logging {\n\t\tenable = true \n\t}",
		"remediationType": "addition",
	}
}
