package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EKS::Nodegroup"
	remoteAccess := resource.Properties.RemoteAccess

	common_lib.valid_key(remoteAccess, "Ec2SshKey")

	not common_lib.valid_key(remoteAccess, "SourceSecurityGroups")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.RemoteAccess", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.RemoteAccess.SourceSecurityGroups' should be defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.RemoteAccess.Source SecurityGroups' is undefined or null", [name]),
	}
}
