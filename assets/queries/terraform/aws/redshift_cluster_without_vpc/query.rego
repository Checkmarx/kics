package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_redshift_cluster[name]

	attributes := {"vpc_security_group_ids", "cluster_subnet_group_name"}

	object.get(resource, attributes[x], "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "Missing Attribute",
		"keyExpectedValue": sprintf("aws_redshift_cluster[%s].%s is set", [name, attributes[x]]),
		"keyActualValue": sprintf("aws_redshift_cluster[%s].%s is undefined", [name, attributes[x]]),
	}
}
