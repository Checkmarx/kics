package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_vpc[vpcName]

	not with_network_firewall(vpcName)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_vpc",
		"resourceName": vpcName,
		"searchKey": sprintf("aws_vpc[%s]", [vpcName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_vpc[%s] has an 'aws_networkfirewall_firewall' associated", [vpcName]),
		"keyActualValue": sprintf("aws_vpc[%s] does not have an 'aws_networkfirewall_firewall' associated", [vpcName]),
		"searchLine": common_lib.build_search_line(["resource", "aws_vpc", vpcName], []),
	}
}

with_network_firewall(vpcName) {
	networkFirewall := input.document[_].resource.aws_networkfirewall_firewall[_]
	split(networkFirewall.vpc_id, ".")[1] == vpcName
}
