package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_route[name]

	common_lib.valid_key(resource, "vpc_peering_connection_id")

	open_cidr(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_route",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_route[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_route[%s] restricts CIDR", [name]),
		"keyActualValue": sprintf("aws_route[%s] does not restrict CIDR", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_route", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_route_table[name]

	route_table_open_cidr(resource.route)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_route",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_route_table[%s].route", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_route_table[%s].route restricts CIDR", [name]),
		"keyActualValue": sprintf("aws_route_table[%s].route does not restrict CIDR", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_route_table", name, "route"], []),
	}
}

openCidrs := {"cidr_block": "0.0.0.0/0", "ipv6_cidr_block": "::/0", "destination_cidr_block": "0.0.0.0/0", "destination_ipv6_cidr_block": "::/0"}

open_cidr(resource) {
	resource[x] == openCidrs[x]
} else {
	routeTableName := split(resource.route_table_id, ".")[1]
	routeTable := input.document[_].resource.aws_route_table[routeTableName]

	unrestricted(routeTable.route)
}

unrestricted(route) {
	is_array(route)
	route[r][x] == openCidrs[x]
} else {
	is_object(route)
	route[x] == openCidrs[x]
}

route_table_open_cidr(route) {
	is_array(route)
	common_lib.valid_key(route[r], "vpc_peering_connection_id")
	unrestricted(route[r])
} else {
	is_object(route)
	common_lib.valid_key(route, "vpc_peering_connection_id")
	unrestricted(route)
}
