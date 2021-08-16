package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_redshift_cluster[name]

	attributes := {"vpc_security_group_ids", "cluster_subnet_group_name"}
	attr := attributes[_]

	not common_lib.valid_key(resource, attr)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_redshift_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_redshift_cluster[%s].%s is set", [name, attr]),
		"keyActualValue": sprintf("aws_redshift_cluster[%s].%s is undefined", [name, attr]),
	}
}
