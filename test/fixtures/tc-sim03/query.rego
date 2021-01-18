package Cx

################################################
# slightly changing the original query to verify
# that similarity ID is query independant
################################################
CxPolicy[result] {
	public := input.document[i].resource.aws_redshift_cluster[name]

	# change
	field := object.get(public, "publicly_accessible", "undefined")
	field == "undefined"

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

	# change :: original query is:
	# public.publicly_accessible == true
	public.publicly_accessible != false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s].publicly_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_redshift_cluster.publicly_accessible is false",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is true",
	}
}
