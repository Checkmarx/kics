package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EKS::Nodegroup"
	remoteAccess := resource.Properties.RemoteAccess

	common_lib.valid_key(remoteAccess, "Ec2SshKey")

	not common_lib.valid_key(remoteAccess, "SourceSecurityGroups")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.RemoteAccess", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.RemoteAccess.SourceSecurityGroups' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.RemoteAccess.Source SecurityGroups' is undefined or null", [name]),
	}
}
