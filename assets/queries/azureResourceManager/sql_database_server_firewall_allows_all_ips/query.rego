package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	types := ["Microsoft.Sql/servers/firewallRules", "firewallRules", "firewallrules"]
	doc := input.document[i]

	[path, value] := walk(doc)
	value.type == types[x]

	properties := value.properties
	check_all_ips(properties.startIpAddress, properties.endIpAddress)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.endIpAddress", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "endIpAddress is not '255.255.255.255' when startIpAddress is '0.0.0.0'",
		"keyActualValue": sprintf("endIpAddress is '%s' and startIpAddress is '%s'", [properties.endIpAddress, properties.startIpAddress]),
	}
}

check_all_ips(start, end) {
	ipsOpts := ["0.0.0.0", "0.0.0.0/0"]
	start == ipsOpts[_]
	end == "255.255.255.255"
}
