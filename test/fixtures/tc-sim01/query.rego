package Cx

################################################
# slightly changing the original query to verify
# that similarity ID is query independant
################################################
CxPolicy[result] {
	public := input.document[i].resource.aws_redshift_cluster[name]
	object.get(public, "publicly_accessible", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		# change :: original is MissingAttribute
		"issueType": "WrongValue",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible should be defined",
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
		# change
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible should be set to false",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is true",
	}
}
