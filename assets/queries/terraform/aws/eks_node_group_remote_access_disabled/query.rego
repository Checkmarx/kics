package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	eksNodeGroup := doc.resource.aws_eks_node_group[name]
	remoteAccess := eksNodeGroup.remote_access

	common_lib.valid_key(remoteAccess, "ec2_ssh_key")
	not common_lib.valid_key(remoteAccess, "source_security_groups_ids")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_eks_node_group[%s].remote_access", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_eks_node_group[%s].remote_access.source_security_groups_ids' is defined and not null", [name]),
		"keyActualValue": sprintf("'aws_eks_node_group[%s].remote_access.source_security_groups_ids' is undefined or null", [name]),
	}
}
