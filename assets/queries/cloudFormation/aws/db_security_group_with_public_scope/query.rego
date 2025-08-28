package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	not input.document[i].Resources[name].Type == "AWS::RDS::DBSecurityGroup"
	resource := input.document[i].Resources[name]
	check_public(resource)
	some j
	res := input.document[i].Resources[j]
	res.Type == "AWS::EC2::SecurityGroup"
	not res.Properties.SecurityGroupIngress[x].CidrIpv6
	ipv4 := res.Properties.SecurityGroupIngress[x].CidrIp
	ipv4 == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": res.Type,
		"resourceName": cf_lib.get_resource_name(res, j),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' should not be '0.0.0.0/0'.", [j]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' is '0.0.0.0/0'.", [j]),
	}
}

CxPolicy[result] {
	not input.document[i].Resources[name].Type == "AWS::RDS::DBSecurityGroup"
	resource := input.document[i].Resources[name]
	check_public(resource)
	some j
	res := input.document[i].Resources[j]
	res.Type == "AWS::EC2::SecurityGroup"
	not res.Properties.SecurityGroupIngress[x].CidrIp
	ipv6 := res.Properties.SecurityGroupIngress[x].CidrIpv6
	ipv6 == "::/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": res.Type,
		"resourceName": cf_lib.get_resource_name(res, j),
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' should not be '0.0.0.0/0'.", [j]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress' is '0.0.0.0/0'.", [j]),
	}
}

CxPolicy[result] {
	not input.document[i].Resources[name].Type == "AWS::EC2::SecurityGroup"
	resource := input.document[i].Resources[name]
	check_public(resource)
	some j
	res := input.document[i].Resources[j]
	res.Type == "AWS::RDS::DBSecurityGroup"
	ipv4 := res.Properties.DBSecurityGroupIngress[x].CIDRIP
	ipv4 == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": res.Type,
		"resourceName": cf_lib.get_resource_name(res, j),
		"searchKey": sprintf("Resources.%s.Properties.DBSecurityGroupIngress", [j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress' should not be '0.0.0.0/0'.", [j]),
		"keyActualValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress' is '0.0.0.0/0'.", [j]),
	}
}

check_public(resource) {
	resource.Type == "AWS::RDS::DBInstance"
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)
}
