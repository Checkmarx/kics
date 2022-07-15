package Cx

import data.generic.common as commonLib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
	policyName := resource.Properties.Policies[j].PolicyName
	protocol := resource.Properties.Policies[j].Attributes[k].Name
	commonLib.inArray({"Protocol-SSLv2", "Protocol-SSLv3", "Protocol-TLSv1", "Protocol-TLSv1.1"}, protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Policies.PolicyName=%s.Attributes.Name=%s", [name, policyName, protocol]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Policies.%s.Attributes.%s' should not be an insecure protocol", [name, policyName, protocol]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Policies.%s.Attributes.%s' is an insecure protocol", [name, policyName, protocol]),
	}
}
