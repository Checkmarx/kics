package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	types := ["AWS::EC2::SecurityGroup","AWS::RDS::DBSecurityGroup"]
	resource := input.document[i].Resources[name]
	is_public_dbinstance(resource)
	res := input.document[i].Resources[j]
	res.Type == types[t]
	results := exposed_inline_ingress(res,j)
	results != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": res.Type,
		"resourceName": cf_lib.get_resource_name(res, j),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		#missing searchLine - TODO
	}
}

#searchKey to be updated - cant because of simId
exposed_inline_ingress(res,index) = results {
	not res.Properties.SecurityGroupIngress[x].CidrIpv6
	ipv4 := res.Properties.SecurityGroupIngress[x].CidrIp
	ipv4 == "0.0.0.0/0"

	results := {
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp' should not be '0.0.0.0/0'.", [index,x]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp' is '0.0.0.0/0'.", [index,x]),
	}
} else = results {
	not res.Properties.SecurityGroupIngress[x].CidrIp
	ipv6 := res.Properties.SecurityGroupIngress[x].CidrIpv6
	ipv6 == "::/0"

	results := {
		"searchKey": sprintf("Resources.%s.Properties.SecurityGroupIngress", [index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6' should not be '::/0'.", [index,x]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6' is '::/0'.", [index,x]),
	}
} else = results {
	ipv4 := res.Properties.DBSecurityGroupIngress[x].CIDRIP
	ipv4 == "0.0.0.0/0"
	results := {
		"searchKey": sprintf("Resources.%s.Properties.DBSecurityGroupIngress", [index]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress[%d].CIDRIP' should not be '0.0.0.0/0'.", [index,x]),
		"keyActualValue": sprintf("'Resources.%s.Properties.DBSecurityGroupIngress[%d].CIDRIP' is '0.0.0.0/0'.", [index,x]),
	}

} else = ""

is_public_dbinstance(resource) {
	resource.Type == "AWS::RDS::DBInstance"
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)
} else {
	resource.Type == "AWS::RDS::DBInstance" 
	not common_lib.valid_key(resource.Properties, "PubliclyAccessible") #default value varies so true is assumed 
}
