package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

resources := {
	"AWS::CloudFront::Distribution",
	"AWS::ElasticLoadBalancing::LoadBalancer",
	"AWS::GlobalAccelerator::Accelerator",
	"AWS::EC2::EIP",
	"AWS::Route53::HostedZone"
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == resources[idx]

	not has_shield_advanced(resources[idx])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s has shield advanced associated", [name]),
		"keyActualValue": sprintf("Resources.%s does not have shield advanced associated", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name], []),
	}
}

has_shield_advanced(resource) {
	shield := input.document[i].Resources[_]
	shield.Type == "AWS::FMS::Policy"

	shield.Properties.SecurityServicePolicyData.Type == "SHIELD_ADVANCED"
	shield.Properties.ResourceTypeList[_] == resource
}
