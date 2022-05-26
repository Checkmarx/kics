package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::VPC"

	not attachedToResources(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s' is attached to resources", [name]),
		"keyActualValue": sprintf("'Resources.%s' is not attached to resources", [name]),
	}
}

attachedToResources(vpcName) {
	some subnet
	resource := input.document[i].Resources[subnet]
	resource.Type == "AWS::EC2::Subnet"
	refers(resource.Properties.VpcId, vpcName)
}

refers(obj, name) {
	obj.Ref == name
}

refers(obj, name) {
	obj == name
}
