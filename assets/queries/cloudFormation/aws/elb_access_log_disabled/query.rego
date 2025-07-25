package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
	prop := resource.Properties
	checkALP(prop)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AccessLoggingPolicy' should exist", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AccessLoggingPolicy' is missing", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
	prop := resource.Properties
	checkALPAttr(prop)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AccessLoggingPolicy.Enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AccessLoggingPolicy.Enabled' is true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AccessLoggingPolicy.Enabled' is false", [name]),
	}
}

checkALP(prop) {
	not common_lib.valid_key(prop, "AccessLoggingPolicy")
}

checkALPAttr(prop) {
	cf_lib.isCloudFormationFalse(prop.AccessLoggingPolicy.Enabled)
}
