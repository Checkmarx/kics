package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"

	# get subnet group name
	subnetGroupName := get_name(resource.Properties.DBSubnetGroupName)

	# get subnet group
	docsAux := input.document[_]
	[_, ResourcesAux] := walk(docsAux)
	sg := ResourcesAux[subnetGroupName]
	sg.Type == "AWS::RDS::DBSubnetGroup"

	# get subnets info
	subnets := sg.Properties.SubnetIds

	# verify if some subnet is public
	is_public(subnets)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DBSubnetGroupName", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RDS should not be running in a public subnet",
		"keyActualValue": "RDS is running in a public subnet",
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "DBSubnetGroupName"]),
	}
}

get_name(subnetGroupName) = name {
	not common_lib.valid_key(subnetGroupName, "Ref")
	name := subnetGroupName
} else = name {
	name := subnetGroupName.Ref
}

unrestricted_cidr(sb) {
	sb.Properties.CidrBlock == "0.0.0.0/0"
} else {
	sb.Properties.Ipv6CidrBlock == "::/0"
}

is_public(subnets) {
	subnet := subnets[_]
	subnetName := get_name(subnet)
	sb := input.document[_].Resources[subnetName]
	sb.Type == "AWS::EC2::Subnet"
	unrestricted_cidr(sb)
}
