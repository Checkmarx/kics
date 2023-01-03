package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SageMaker::EndpointConfig"
	properties := resource.Properties
	not common_lib.valid_key(properties, "KmsKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsKeyId should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsKeyId is undefined", [name]),
	}
}
