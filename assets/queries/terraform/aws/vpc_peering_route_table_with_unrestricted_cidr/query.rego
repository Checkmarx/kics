package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_route[name]

	common_lib.valid_key(resource, "vpc_peering_connection_id")

	open_cidr(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_route[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_route[%s] restricts CIDR", [name]),
		"keyActualValue": sprintf("aws_route[%s] does not restrict CIDR", [name]),
	}
}

openCidrs := {"cidr_block": "0.0.0.0/0", "ipv6_cidr_block": "::/0"}

open_cidr(resource) {
	vpcPeeringName := split(resource.vpc_peering_connection_id, ".")[2]
	vpcPeering := input.document[_].data.aws_vpc_peering_connection[vpcPeeringName]
	vpcPeering.peer_cidr_block == openCidrs[_]
} else {
	resource[x] == openCidrs[x]
} else {
	routeTableName := split(resource.route_table_id, ".")[1]
	routeTable := input.document[_].resource.aws_route_table[routeTableName]
	route := routeTable.route[r]

	route[x] == openCidrs[x]
}
