package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	eksNodeGroup := doc.resource.aws_eks_node_group[name]
	remoteAccess := eksNodeGroup.remote_access

	common_lib.valid_key(remoteAccess, "ec2_ssh_key")
	not common_lib.valid_key(remoteAccess, "source_security_groups_ids")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_eks_node_group",
		"resourceName": tf_lib.get_resource_name(eksNodeGroup, name),
		"searchKey": sprintf("aws_eks_node_group[%s].remote_access", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_eks_node_group[%s].remote_access.source_security_groups_ids' should be defined and not null", [name]),
		"keyActualValue": sprintf("'aws_eks_node_group[%s].remote_access.source_security_groups_ids' is undefined or null", [name]),
	}
}
