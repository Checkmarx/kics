package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	some name in Resources

	resource := Resources[name]
	resource.Type == "AWS::EC2::VPC"

	not attachedToResources(name)

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s' should be attached to resources", [name]),
		"keyActualValue": sprintf("'Resources.%s' is not attached to resources", [name]),
	}
}

attachedToResources(vpcName) {
	some subnet
	some doc in input.document
	resource := doc.Resources[subnet]
	resource.Type == "AWS::EC2::Subnet"
	refers(resource.Properties.VpcId, vpcName)
}

refers(obj, name) {
	obj.Ref == name
}

refers(obj, name) {
	obj == name
}
