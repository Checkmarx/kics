package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	public := input.document[i].resource.aws_redshift_cluster[name]
	not common_lib.valid_key(public, "publicly_accessible")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible is defined and not null",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is undefined or null",
	}
}

CxPolicy[result] {
	public := input.document[i].resource.aws_redshift_cluster[name]
	public.publicly_accessible == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s].publicly_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible is false",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is true",
	}
}
