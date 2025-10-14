package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

valid_encryption_values := ["KMS_DSSE","KMS"]

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

	common_lib.valid_key(resource.Properties, "EncryptionConfiguration")
	encryption_config := resource.Properties.EncryptionConfiguration
	encryption_type := encryption_config.EncryptionType
	results := valid_encryption_configuration(encryption_config,encryption_type,name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
	}
}

valid_encryption_configuration(encryption_config,encryption_type,name) = results {
	not common_lib.inArray(valid_encryption_values,encryption_type)
	results := {
		"searchKey" : sprintf("Resources.%s.Properties.EncryptionConfiguration.EncryptionType", [name]),
		"issueType" : "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionConfiguration.EncryptionType should be 'KMS_DSSE' or 'KMS'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionConfiguration.EncryptionType is '%s'", [name,encryption_type]),
		"searchLine" : common_lib.build_search_line(["Resources", name,"Properties","EncryptionConfiguration","EncryptionType"],[]),
	}
} else = results {
	common_lib.inArray(valid_encryption_values,encryption_type)
	not common_lib.valid_key(encryption_config, "KmsKey")
	results := {
		"searchKey" : sprintf("Resources.%s.Properties.EncryptionConfiguration", [name]),
		"issueType" : "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionConfiguration.KmsKey should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionConfiguration.KmsKey is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["Resources", name,"Properties","EncryptionConfiguration"],[]),
	}
}
