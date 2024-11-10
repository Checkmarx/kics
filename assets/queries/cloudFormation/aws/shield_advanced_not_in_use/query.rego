package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

resources := {
	"AWS::CloudFront::Distribution",
	"AWS::ElasticLoadBalancing::LoadBalancer",
	"AWS::GlobalAccelerator::Accelerator",
	"AWS::EC2::EIP",
	"AWS::Route53::HostedZone",
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == resources[idx]

	not has_shield_advanced(resources[idx])

	result := {
		"documentId": doc.id,
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
	some doc in input.document
	some shield in doc.Resources
	shield.Type == "AWS::FMS::Policy"

	shield.Properties.SecurityServicePolicyData.Type == "SHIELD_ADVANCED"
	resource in shield.Properties.ResourceTypeList
}
