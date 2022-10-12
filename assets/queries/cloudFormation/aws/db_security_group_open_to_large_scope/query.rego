package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"
	not common_lib.valid_key(resource.Properties.SecurityGroupIngress, "CidrIpv6")
	ipv4 := resource.Properties.SecurityGroupIngress.CidrIp
	not check_mask_ipv4(ipv4)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SecurityGroupIngress", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' should not have more than 256 hosts.", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' has more than 256 hosts.", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::SecurityGroup"
	not common_lib.valid_key(resource.Properties.SecurityGroupIngress, "CidrIp")
	ipv6 := resource.Properties.SecurityGroupIngress.CidrIpv6
	not check_ipv6(ipv6)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SecurityGroupIngress", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' should not have more than 256 hosts.", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' has more than 256 hosts.", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBSecurityGroup"
	ipv4 := resource.Properties.DBSecurityGroupIngress.CIDRIP
	not check_mask_ipv4(ipv4)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DBSecurityGroupIngress", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress' should not have more than 256 hosts.", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress' has more than 256 hosts.", [name]),
	}
}

check_mask_ipv4(ipv4) {
	masks := {"25", "26", "27", "28", "29", "30", "31", "32"}
	output := split(ipv4, "/")
	masks[_] == output[1]
}

check_ipv6(ipv6) {
	prefixes := {"120", "121", "122", "123", "124", "125", "126", "127", "128"}
	output := split(ipv6, "/")
	prefixes[_] == output[1]
}
