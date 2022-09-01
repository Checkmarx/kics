package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::NetworkAclEntry"
	protocol := resource.Properties.Protocol
	not checkValue(protocol)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Protocol' should be either 6 (for TCP), 17 (for UDP), 1 (for ICMP), or 58 (for ICMPv6, which must include an IPv6 CIDR block, ICMP type, and code)", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Protocol' is configured with a protocol different than 6 (for TCP), 17 (for UDP), 1 (for ICMP), or 58 (for ICMPv6, which must include an IPv6 CIDR block, ICMP type, and code)", [name]),
	}
}

checkValue(protocol) {
	prt := to_number(protocol)
	prt == 6
}

checkValue(protocol) {
	prt := to_number(protocol)
	prt == 17
}

checkValue(protocol) {
	prt := to_number(protocol)
	prt == 1
}

checkValue(protocol) {
	prt := to_number(protocol)
	prt == 58
}
