package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"

	not common_lib.valid_key(resource.Properties, "EncryptionConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionConfiguration should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionConfiguration is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name,"Properties"],[])
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"
	valid_encryption_values := ["KMS_DSSE","KMS"]

	common_lib.valid_key(resource.Properties, "EncryptionConfiguration")
	encryption_type := resource.Properties.EncryptionConfiguration.EncryptionType
	not common_lib.inArray(valid_encryption_values,encryption_type) 

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.EncryptionConfiguration.EncryptionType", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionConfiguration.EncryptionType should be 'KMS_DSSE' or 'KMS'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionConfiguration.EncryptionType is '%s'", [name,encryption_type]),
		"searchLine": common_lib.build_search_line(["Resources", name,"Properties","EncryptionConfiguration","EncryptionType"],[])
	}
}
