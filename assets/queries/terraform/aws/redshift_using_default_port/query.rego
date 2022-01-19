package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	redshift := input.document[i].resource.aws_redshift_cluster[name]
	not common_lib.valid_key(redshift, "port")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_redshift_cluster.port is defined and not null",
		"keyActualValue": "aws_redshift_cluster.port is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_redshift_cluster", name], []),
	}
}

CxPolicy[result] {
	redshift := input.document[i].resource.aws_redshift_cluster[name]
	redshift.port == 5439

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s].port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.port is not set to 5439",
		"keyActualValue": "aws_redshift_cluster.port is set to 5439",
		"searchLine": common_lib.build_search_line(["resource", "aws_redshift_cluster", name, "port"], []),
	}
}
