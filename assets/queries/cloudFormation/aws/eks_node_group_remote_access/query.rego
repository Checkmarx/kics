package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::EKS::Nodegroup"
	remoteAccess := resource.Properties.RemoteAccess

	common_lib.valid_key(remoteAccess, "Ec2SshKey")

	not common_lib.valid_key(remoteAccess, "SourceSecurityGroups")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.RemoteAccess", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.RemoteAccess.SourceSecurityGroups' should be defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.RemoteAccess.Source SecurityGroups' is undefined or null", [name]),
	}
}
