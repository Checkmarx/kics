package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
	prop := resource.Properties

	not common_lib.valid_key(prop, "LoadBalancerAttributes")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties' has LoadBalancerAttributes defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties' doesn't have LoadBalancerAttributes defined", [name]),
	}
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::ElasticLoadBalancingV2::LoadBalancer"
	prop := resource.Properties

	containsKeyValue(prop.LoadBalancerAttributes, "access_logs.s3.enabled")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoadBalancerAttributes", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoadBalancerAttributes' has access_logs.s3.enabled with Value true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoadBalancerAttributes' doesn't have access_logs.s3.enabled with Value true", [name]),
	}
}

containsKeyValue(arr, elem) {
	arr[i].Key == elem
	arr[i].Value == false
}
