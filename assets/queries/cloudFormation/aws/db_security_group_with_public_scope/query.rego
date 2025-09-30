package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	is_public_dbinstance(resource)
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
	resource := input.document[i].Resources[name]
	is_public_dbinstance(resource)
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
	resource := input.document[i].Resources[name]
	is_public_dbinstance(resource)
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

is_public_dbinstance(resource) {
	resource.Type == "AWS::RDS::DBInstance"
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)
} else {
	resource.Type == "AWS::RDS::DBInstance"
	common_lib.valid_key(resource.Properties.PubliclyAccessible)
}
