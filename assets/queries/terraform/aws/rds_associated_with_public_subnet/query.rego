package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]

	# get subnet group name
	subnetGroupName := get_name(db.db_subnet_group_name)

	# get subnet group
	sg := input.document[_].resource.aws_db_subnet_group[subnetGroupName]

	# get subnets info
	subnets := sg.subnet_ids

	# verify if some subnet is public
	is_public(subnets)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(db, name),
		"searchKey": sprintf("aws_db_instance[%s].db_subnet_group_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RDS should not be running in a public subnet",
		"keyActualValue": "RDS is running in a public subnet",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "db_subnet_group_name"], []),
	}
}

options := { "${aws_db_subnet_group", "${aws_subnet" }

get_name(nameValue) = name {
	contains(nameValue, options[_])
	name := split(nameValue, ".")[1]
} else = name {
	op := options[_]
	not contains(nameValue, options[op])
	name := nameValue
}

unrestricted_cidr(sb) {
	sb.cidr_block == "0.0.0.0/0"
} else {
	sb.ipv6_cidr_block == "::/0"
}

is_public(subnets) {
	subnet := subnets[_]
	subnetName := get_name(subnet)
	sb := input.document[_].resource.aws_subnet[subnetName]
	unrestricted_cidr(sb)
}
