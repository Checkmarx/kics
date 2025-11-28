package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

cidr_fields := ["CidrIp","CidrIpv6","CIDRIP"]

CxPolicy[result] {
	types := ["AWS::EC2::SecurityGroup","AWS::RDS::DBSecurityGroup","AWS::RDS::DBSecurityGroupIngress","AWS::EC2::SecurityGroupIngress"]
	db := input.document[i].Resources[name]
	db.Type == "AWS::RDS::DBInstance"
	is_public_db(db)

	referenced_sec_groups := [x | x := cf_lib.get_name(db.Properties[["VPCSecurityGroups","DBSecurityGroups"][_]][_])]
	resource := input.document[y].Resources[resource_name]
	resource.Type == types[_]

	is_associated_with_db(resource, resource_name, referenced_sec_groups)

	ingress_list := cf_lib.get_ingress_list(resource)
	results := exposed_inline_or_standalone_ingress(ingress_list[ing_index], ing_index, resource.Type, resource_name)

	result := {
		"documentId": input.document[y].id,
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

	res[cidr_fields[x2]] == common_lib.unrestricted_ips[x3]  # standalone ipv4 or ipv6

	ingress_field_name := get_ingress_field_name(type)

	results := {
		"searchKey": sprintf("Resources.%s.Properties.%s[%d].%s", [resource_index, ingress_field_name, ing_index, cidr_fields[x2]]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s[%d].%s' should not be '%s'.", [resource_index, ingress_field_name, ing_index, cidr_fields[x2], common_lib.unrestricted_ips[x3]]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s[%d].%s' is '%s'.", [resource_index, ingress_field_name, ing_index, cidr_fields[x2], common_lib.unrestricted_ips[x3]]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", ingress_field_name, ing_index, cidr_fields[x2]],[])
	}
} else = results { 																					# standalone ingress resources
	type == ["AWS::EC2::SecurityGroupIngress", "AWS::RDS::DBSecurityGroupIngress"][x1]

	res[cidr_fields[x2]] == common_lib.unrestricted_ips[x3]  # standalone ipv4 or ipv6

	results := {
		"searchKey": sprintf("Resources.%s.Properties.%s", [resource_index, cidr_fields[x2]]),
		"keyExpectedValue": sprintf("'Resources.%s.Properties.%s' should not be '%s'.", [resource_index, cidr_fields[x2], common_lib.unrestricted_ips[x3]]),
		"keyActualValue": sprintf("'Resources.%s.Properties.%s' is '%s'.", [resource_index, cidr_fields[x2], common_lib.unrestricted_ips[x3]]),
		"searchLine" : common_lib.build_search_line(["Resources", resource_index, "Properties", cidr_fields[x2]],[])
	}
}

get_ingress_field_name("AWS::EC2::SecurityGroup") = "SecurityGroupIngress"
get_ingress_field_name("AWS::RDS::DBSecurityGroup") = "DBSecurityGroupIngress"

is_associated_with_db(resource, resource_name, referenced_sec_groups) {			# case of sec_group
	resource_name == referenced_sec_groups[_]
} else {																		# case of EC2 ingress
	cf_lib.get_name(resource.Properties.GroupId) == referenced_sec_groups[_]
} else {																		# case of DB ingress (legacy)
	cf_lib.get_name(resource.Properties.DBSecurityGroupName) == referenced_sec_groups[_]
}

is_public_db(resource) {
	common_lib.valid_key(resource.Properties, "PubliclyAccessible")
	cf_lib.isCloudFormationTrue(resource.Properties.PubliclyAccessible)
} else {
	not common_lib.valid_key(resource.Properties, "PubliclyAccessible")
	not common_lib.valid_key(resource.Properties, "DBSubnetGroupName")
}
