package Cx

import data.generic.common as common_lib

#default of mfa_delete is false
CxPolicy[result] {
	ver := input.document[i].resource.aws_s3_bucket[name].versioning
	not common_lib.valid_key(ver, "mfa_delete")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning.mfa_delete", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'mfa_delete' is equal 'true'",
		"keyActualValue": "'mfa_delete' is missing",
	}
}

CxPolicy[result] {
	ver := input.document[i].resource.aws_s3_bucket[name].versioning
	ver.mfa_delete != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning.mfa_delete", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'mfa_delete' is equal 'true'",
		"keyActualValue": "'mfa_delete' is equal 'false'",
	}
}
