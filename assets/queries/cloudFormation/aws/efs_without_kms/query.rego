package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::EFS::FileSystem"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.Encrypted)
	not common_lib.valid_key(properties, "KmsKeyId")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("EFS resource '%s' should have encryption enabled using KMS CMK customer-managed keys instead of AWS managed-keys", [name]),
		"keyActualValue": sprintf("EFS resource '%s' is not encrypted using KMS CMK customer-managed keys instead of AWS managed-keys", [name]),
	}
}
