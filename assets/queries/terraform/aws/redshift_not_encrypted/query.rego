package Cx

CxPolicy[result] {
	cluster := input.document[i].resource.aws_redshift_cluster[name]
	object.get(cluster, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_redshift_cluster.encrypted is defined",
		"keyActualValue": "aws_redshift_cluster.encrypted is undefined",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.aws_redshift_cluster[name]
	cluster.encrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s].encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.encrypted is false",
		"keyActualValue": "aws_redshift_cluster.encrypted is true",
	}
}
