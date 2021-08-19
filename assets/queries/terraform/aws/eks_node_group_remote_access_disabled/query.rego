package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	eksNodeGroup := input.document[i].resource.aws_eks_node_group[name]
	remoteAccess := eksNodeGroup.remote_access

	common_lib.valid_key(remoteAccess, "ec2_ssh_key")

	not common_lib.valid_key(remoteAccess, "source_security_groups")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_eks_node_group[%s].remote_access", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'source_security_groups_ids' is defined and not null", [name]),
		"keyActualValue": sprintf("'source_security_groups_ids' is undefined or null", [name]),
	}
}
