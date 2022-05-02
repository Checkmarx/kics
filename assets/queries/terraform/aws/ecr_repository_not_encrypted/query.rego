package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]

	not common_lib.valid_key(resource, "encryption_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'encryption_configuration' is defined with 'KMS' as encryption type and a KMS key ARN",
		"keyActualValue": "'encryption_configuration' is undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]

	common_lib.valid_key(resource, "encryption_configuration")
	not valid_encryption_configuration(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository[%s].encryption_configuration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'encryption_configuration.encryption_type' is set to 'KMS' and 'encryption_configuration.kms_key' specifies a KMS key ARN",
		"keyActualValue": "'encryption_configuration.encryption_type' is not set to 'KMS' and/or 'encryption_configuration.kms_key' does not specify a KMS key ARN",
	}
}

valid_encryption_configuration(resource) {
	resource.encryption_configuration.encryption_type == "KMS"
	common_lib.valid_key(resource.encryption_configuration, "kms_key")
}
