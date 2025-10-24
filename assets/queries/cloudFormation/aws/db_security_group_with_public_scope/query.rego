package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

cidr_fields := ["CidrIp","CidrIpv6","CIDRIP"]

CxPolicy[result] {
	types := ["AWS::EC2::SecurityGroup","AWS::RDS::DBSecurityGroup","AWS::RDS::DBSecurityGroupIngress","AWS::EC2::SecurityGroupIngress"]
	doc := input.document[i]
	public_db := doc.Resources[name]
	public_db.Type == "AWS::RDS::DBInstance"
	is_public_db(public_db)

	resource := doc.Resources[resource_name]
	resource.Type == types[_]

	ingress_list := cf_lib.get_ingress_list(resource)
	results := exposed_inline_or_standalone_ingress(ingress_list[ing_index], ing_index, resource.Type, resource_name)

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, resource_name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine" : results.searchLine,
	}
}

exposed_inline_or_standalone_ingress(res, ing_index, type, resource_index) = results { 				# inline ingresses
	type == ["AWS::EC2::SecurityGroup", "AWS::RDS::DBSecurityGroup"][x1]

	unrestricted_ips := array.concat(common_lib.unrestricted_ipv6, ["0.0.0.0/0"])
	res[cidr_fields[x2]] == unrestricted_ips[x3]  #standalone ipv4 or ipv6

	ingress_field_name := get_ingress_field_name(type)

	results := {
		"searchKey": sprintf("Resources.%s.Properties.%s[%d].%s", [resource_index, ingress_field_name, ing_index, cidr_fields[x2]]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s[%d].%s' should not be '%s'.", [resource_index, ingress_field_name, ing_index, cidr_fields[x2], unrestricted_ips[x3]]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s[%d].%s' is '%s'.", [resource_index, ingress_field_name, ing_index, cidr_fields[x2], unrestricted_ips[x3]]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", ingress_field_name, ing_index, cidr_fields[x2]],[])
	}
} else = results { 																					# standalone ingress resources
	type == ["AWS::EC2::SecurityGroupIngress", "AWS::RDS::DBSecurityGroupIngress"][x1]

	unrestricted_ips := array.concat(common_lib.unrestricted_ipv6, ["0.0.0.0/0"])
	res[cidr_fields[x2]] == unrestricted_ips[x3]  #standalone ipv4 or ipv6

	results := {
		"searchKey": sprintf("Resources.%s.Properties.%s", [resource_index, cidr_fields[x2]]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s' should not be '%s'.", [resource_index, cidr_fields[x2], unrestricted_ips[x3]]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s' is '%s'.", [resource_index, cidr_fields[x2], unrestricted_ips[x3]]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", cidr_fields[x2]],[])
	}
}

get_ingress_field_name("AWS::EC2::SecurityGroup") = "SecurityGroupIngress"
get_ingress_field_name("AWS::RDS::DBSecurityGroup") = "DBSecurityGroupIngress"

is_public_db(resource) {
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)
} else {
	not common_lib.valid_key(resource.Properties, "PubliclyAccessible") #default value varies so true is assumed
}
