package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::NetworkAclEntry"
	protocol := resource.Properties.Protocol
	not checkValue(protocol)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Protocol' should be hould be either 6 (for TCP), 17 (for UDP), 1 (for ICMP), or 58 (for ICMPv6, which must include an IPv6 CIDR block, ICMP type, and code)", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Protocol' is configured with a protocol different then 6 (for TCP), 17 (for UDP), 1 (for ICMP), or 58 (for ICMPv6, which must include an IPv6 CIDR block, ICMP type, and code)", [name]),
	}
}

checkValue(protocol) {
	is_number(protocol)
	protocol == 6
}

checkValue(protocol) {
	is_number(protocol)
	protocol == 17
}

checkValue(protocol) {
	is_number(protocol)
	protocol == 1
}

checkValue(protocol) {
	is_number(protocol)
	protocol == 58
}

checkValue(protocol) {
	is_string(protocol)
	protocol == "6"
}

checkValue(protocol) {
	is_string(protocol)
	protocol == "17"
}

checkValue(protocol) {
	is_string(protocol)
	protocol == "1"
}

checkValue(protocol) {
	is_string(protocol)
	protocol == "58"
}
