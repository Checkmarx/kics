package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	not common_lib.valid_key(properties, "ClientCertificateId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties should have ClientCertificateId defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties doesn't have ClientCertificateId defined", [name]),
	}
}
