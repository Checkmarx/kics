package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	cf_lib.isLoadBalancer(resource)
	securityGroup_name := cf_lib.get_name(resource.Properties.SecurityGroups[_])

	not has_standalone_ingress(securityGroup_name)
	value := withoutInboundRules(input.document[i].Resources[securityGroup_name], securityGroup_name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties%s", [securityGroup_name, value.path]),
		"issueType": value.issue,
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' should %s", [securityGroup_name, value.expected]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' is %s", [securityGroup_name, value.actual]),
		"searchLine": common_lib.build_search_line(value.searchlineArray,[])
	}
}

has_standalone_ingress(securityGroup_name) {
	resource := input.document[_].Resources[j]
	resource.Type == "AWS::EC2::SecurityGroupIngress"
	cf_lib.get_name(resource.Properties.GroupId) == securityGroup_name
}

withoutInboundRules(securityGroup,name) = results {
	not common_lib.valid_key(securityGroup.Properties, "SecurityGroupIngress")
	results := {
		"expected": "be defined",
		"actual": "undefined",
		"path": "",
		"issue": "MissingAttribute",
		"searchlineArray": ["Resources", name, "Properties"]
	}
} else = results {
	securityGroup.Properties.SecurityGroupIngress == []
	results := {
		"expected": "not be empty",
		"actual": "empty",
		"path": ".SecurityGroupIngress",
		"issue": "IncorrectValue",
		"searchlineArray": ["Resources", name, "Properties", "SecurityGroupIngress"]
	}
}
