package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EC2::Volume"

	properties := resource.Properties

	not common_lib.valid_key(properties, "KmsKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsKeyId should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsKeyId is undefined", [key]),
	}
}
