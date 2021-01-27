package Cx

CxPolicy[result] {
	public := input.document[i].resource.aws_redshift_cluster[name]
	object.get(public, "publicly_accessible", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible is defined",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is undefined",
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
