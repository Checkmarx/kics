package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_vpc_endpoint[name]

	serviceNameSplit := split(resource.service_name, ".")
	serviceNameSplit[minus(count(serviceNameSplit), 1)] == "dynamodb"
	vpcNameRef := split(resource.vpc_id, ".")[1]

	not has_route_association(vpcNameRef)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_vpc_endpoint",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_vpc_endpoint[%s].vpc_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Dynamodb VPC Endpoint should be associated with Route Table Association",
		"keyActualValue": "Dynamodb VPC Endpoint is not associated with Route Table Association",
	}
}

has_route_association(vpcNameRef) {
	route := input.document[j].resource.aws_route_table[routeName]
	split(route.vpc_id, ".")[1] == vpcNameRef

	subnet := input.document[k].resource.aws_subnet[subnetName]
	split(subnet.vpc_id, ".")[1] == vpcNameRef

	routeAssociation := input.document[z].resource.aws_route_table_association[routeAssociationName]
	split(routeAssociation.route_table_id, ".")[1] == routeName
	split(routeAssociation.subnet_id, ".")[1] == subnetName
}
