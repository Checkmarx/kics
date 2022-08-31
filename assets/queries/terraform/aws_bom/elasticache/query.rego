package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	elasticache := input.document[i].resource.aws_elasticache_cluster[name]

	bom_output = {
		"resource_type": "aws_elasticache_cluster",
		"resource_name": tf_lib.get_specific_resource_name(elasticache, "aws_elasticache_cluster", name),
		# memcached or redis
		"resource_engine": get_engine_type(elasticache),
		"resource_accessibility": get_accessibility(elasticache),
		"resource_encryption": "unknown",
		"resource_vendor": "AWS",
		"resource_category": "In Memory Data Structure",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elasticache_cluster[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_elasticache_cluster", name], []),
		"value": json.marshal(bom_output),
	}
}

get_engine_type(aws_elasticache_cluster) = engine_type {
	engine_type := aws_elasticache_cluster.engine
} else = engine_type {
	not aws_elasticache_cluster.replication_group_id
	engine_type := "unknown"
}

unrestricted_cidr(ingress) {
	ingress.cidr_blocks[_] == "0.0.0.0/0"
} else {
	ingress.ipv6_cidr_blocks[_] == "::/0"
}

unrestricted(sg) {
	is_array(sg.ingress)
	ingress := sg.ingress[_]
	unrestricted_cidr(ingress)
} else {
	is_object(sg.ingress)
	unrestricted_cidr(sg.ingress)
}

is_unrestricted(securityGroupName) {
	contains(securityGroupName, "${aws_security_group")
	sg := input.document[_].resource.aws_security_group[split(securityGroupName, ".")[1]]
	unrestricted(sg)
} else {
	contains(securityGroupName, "${aws_elasticache_security_group")
	elasticacheSG := input.document[_].resource.aws_elasticache_security_group[split(securityGroupName, ".")[1]]

	sgName := elasticacheSG.security_group_names[_]
	contains(sgName, "${aws_security_group")

	sg := input.document[_].resource.aws_security_group[split(sgName, ".")[1]]
	unrestricted(sg)
}

options := {"security_group_names", "security_group_ids"}

get_accessibility(elasticache) = accessibility {
	count({
		x | securityGroupInfo := elasticache[options[_]][x];
		is_unrestricted(securityGroupInfo)
	}) > 0

	accessibility := "at least one security group associated with the elasticache is unrestricted"
} else = accessibility {
	count({
		x | securityGroupInfo := elasticache[options[_]][x];
		not is_unrestricted(securityGroupInfo)
	}) == count(elasticache[options[_]])

	accessibility := "all security groups associated with the elasticache are restricted"
} else = accessibility {
	accessibility := "unknown"
}
