package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	elbInstance := doc.Resources[name]

	cf_lib.isLoadBalancer(elbInstance)
	securityGroup_name := cf_lib.get_name(elbInstance.Properties.SecurityGroups[sg])

	not has_standalone_egress(securityGroup_name, doc)
	value := withoutOutboundRules(doc.Resources[securityGroup_name],securityGroup_name)
	value != ""

	result := {
		"documentId": doc.id,
		"resourceType": elbInstance.Type,
		"resourceName": cf_lib.get_resource_name(elbInstance, name),
		"searchKey": sprintf("Resources.%s.Properties%s", [securityGroup_name, value.path]),
		"issueType": value.issue,
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupEgress' should %s", [securityGroup_name, value.expected]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupEgress' is %s", [securityGroup_name, value.actual]),
		"searchLine": common_lib.build_search_line(value.searchlineArray,[])
	}
}

has_standalone_egress(securityGroup_name,doc) {
	resource := doc.Resources[j]
	resource.Type == "AWS::EC2::SecurityGroupEgress"
	cf_lib.get_name(resource.Properties.GroupId) == securityGroup_name
}

withoutOutboundRules(securityGroup,name) = results {
	not common_lib.valid_key(securityGroup.Properties, "SecurityGroupEgress")
	results := {
		"expected": "be defined",
		"actual": "undefined",
		"path": "",
		"issue": "MissingAttribute",
		"searchlineArray": ["Resources", name, "Properties"]
	}
} else = results {
	securityGroup.Properties.SecurityGroupEgress == []
	results := {
		"expected": "not be empty",
		"actual": "empty",
		"path": ".SecurityGroupEgress",
		"issue": "IncorrectValue",
		"searchlineArray": ["Resources", name, "Properties", "SecurityGroupEgress"]
	}
} 
