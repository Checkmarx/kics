package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::EC2::VPC"

	gatewayAttachments := {gatewayAttachment |
		[_, ResourcesAux] := walk(input.document[_])
		some resource in ResourcesAux
		resource.Type == "AWS::EC2::VPCGatewayAttachment"
		refers(resource.Properties.VpcId, name)
		gatewayAttachment := resource
	}

	count(gatewayAttachments) > 3

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s' should not be attached with a number of gateways close to or out of limit (>3)", [name]),
		"keyActualValue": sprintf("'Resources.%s' is attached with a number of gateways close to or out of limit (>3)", [name]),
	}
}

refers(obj, name) {
	obj.Ref == name
}

refers(obj, name) {
	obj == name
}
