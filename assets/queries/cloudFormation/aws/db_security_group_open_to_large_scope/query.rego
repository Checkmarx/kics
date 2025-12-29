package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

cidr_fields := ["CidrIp","CidrIpv6","CIDRIP"]

CxPolicy[result] {
	types := ["AWS::EC2::SecurityGroup","AWS::RDS::DBSecurityGroup","AWS::RDS::DBSecurityGroupIngress","AWS::EC2::SecurityGroupIngress"]

	resource := input.document[i].Resources[name]
	resource.Type == types[_]

	ingress_list := cf_lib.get_ingress_list(resource)
	results := exposed_inline_or_standalone_ingress(ingress_list[ing_index], ing_index, resource.Type, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine" : results.searchLine,
	}
}

large_scope(ip_address, cidr) {
	cidr == "CidrIpv6"
	input_mask := split(ip_address, "/")
	to_number(input_mask[1]) < 120		# should be 120-128
} else {
	input_mask := split(ip_address, "/")
	to_number(input_mask[1]) < 25	# should be 25-32
}

exposed_inline_or_standalone_ingress(res, ing_index, type, resource_index) = results { # inline ingresses
	type == ["AWS::EC2::SecurityGroup", "AWS::RDS::DBSecurityGroup"][x1]

	large_scope(res[cidr_fields[x2]], cidr_fields[x2])

	ingress_field_name := get_ingress_field_name(type)

	results := {
		"searchKey": sprintf("Resources.%s.Properties.%s[%d].%s", [resource_index, ingress_field_name, ing_index, cidr_fields[x2]]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s[%d].%s' should not have more than 256 hosts.", [resource_index, ingress_field_name, ing_index, cidr_fields[x2]]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s[%d].%s' has more than 256 hosts.", [resource_index, ingress_field_name, ing_index, cidr_fields[x2]]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", ingress_field_name, ing_index, cidr_fields[x2]],[])
	}
} else = results { # standalone ingress resources
	type == ["AWS::EC2::SecurityGroupIngress", "AWS::RDS::DBSecurityGroupIngress"][x1]

	large_scope(res[cidr_fields[x2]], cidr_fields[x2])

	results := {
		"searchKey": sprintf("Resources.%s.Properties.%s", [resource_index, cidr_fields[x2]]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s' should not have more than 256 hosts.", [resource_index, cidr_fields[x2]]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s' has more than 256 hosts.", [resource_index, cidr_fields[x2]]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", cidr_fields[x2]],[])
	}
}

get_ingress_field_name("AWS::EC2::SecurityGroup") = "SecurityGroupIngress"
get_ingress_field_name("AWS::RDS::DBSecurityGroup") = "DBSecurityGroupIngress"
