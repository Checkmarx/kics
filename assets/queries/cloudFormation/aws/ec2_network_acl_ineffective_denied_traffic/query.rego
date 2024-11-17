package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::EC2::NetworkAclEntry"
	action := resource.Properties.RuleAction
	cidr := resource.Properties.CidrBlock
	not contains(cidr, "0.0.0.0/0")
	contains(action, "deny")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.CidrBlock", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Traffic denial should be effective (Action is 'Deny' when CidrBlock is '0.0.0.0/0')",
		"keyActualValue": "Traffic denial is ineffective (Action is 'Deny' when CidrBlock is different from '0.0.0.0/0')",
	}
}
