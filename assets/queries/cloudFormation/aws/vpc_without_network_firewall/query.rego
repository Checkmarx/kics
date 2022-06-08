package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::VPC"

	not with_network_firewall(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s' is associated with a AWS Network Firewall", [name]),
		"keyActualValue": sprintf("'Resources.%s' is not associated with a AWS Network Firewall", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name], []),
	}
}

with_network_firewall(vpcName) {
	resource := input.document[_].Resources[_]
	resource.Type == "AWS::NetworkFirewall::Firewall"

	vpcName == get_name(resource.Properties.VpcId)
}

get_name(vpc) = name {
	common_lib.valid_key(vpc, "Ref")
	name := vpc.Ref
} else = name {
	name := vpc
}

