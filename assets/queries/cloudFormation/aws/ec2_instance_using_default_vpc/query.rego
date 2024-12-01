package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::EC2::Instance"

	properties := resource.Properties
	subnetName := properties.SubnetId
	subNetObj := input.document[_].Resources[subnetName]

	vpcInfo := get_name(subNetObj.Properties.VpcId)

	contains(lower(vpcInfo), "default")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.SubnetId", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SubnetId should not be associated with a default VPC", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.SubnetId is associated with a default VPC", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "SubnetId"], []),
	}
}

get_name(vpc) = name {
	name := vpc.Ref
} else = name {
	name := vpc
}
