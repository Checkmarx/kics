package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
    resource := input.document[i].Resources[name]
    resource.Type == "AWS::EKS::Cluster"

    not common_lib.valid_key(resource.Properties, "EncryptionConfig")

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'EncryptionConfig' should be defined with a customer managed KMS key in 'Provider.KeyArn'",
		"keyActualValue": "'EncryptionConfig' is undefined or null, so the default AWS owned KMS key is used",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
    res := input.document[i].Resources[name]
    res.Type == "AWS::EKS::Cluster"

	common_lib.valid_key(res.Properties, "EncryptionConfig")
	not has_customer_managed_key(res.Properties.EncryptionConfig)

    result := {
		"documentId": input.document[i].id,
		"resourceType": res.Type,
		"resourceName": cf_lib.get_resource_name(res, name),
		"searchKey": sprintf("Resources.%s.Properties.EncryptionConfig", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'EncryptionConfig' should define a customer managed KMS key in 'Provider.KeyArn'",
		"keyActualValue": "'EncryptionConfig' does not define 'Provider.KeyArn', so the default AWS owned KMS key is used",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "EncryptionConfig"], [])
	}
}

has_customer_managed_key(encryption_configs) {
	common_lib.valid_key(encryption_configs[_].Provider, "KeyArn")
}
