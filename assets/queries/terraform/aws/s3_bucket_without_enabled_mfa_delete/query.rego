package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(bucket, "versioning")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s].versioning is defined", [name]),
		"keyActualValue": sprintf("aws_s3_bucket[%s].versioning is undefined", [name]),
	}
}

checkedFields = {
	"enabled",
	"mfa_delete"
}

CxPolicy[result] {
	ver := input.document[i].resource.aws_s3_bucket[name].versioning
	not common_lib.valid_key(ver, checkedFields[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning.%s", [name, checkedFields[j]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' is equal 'true'", [checkedFields[j]]),
		"keyActualValue": sprintf("'%s' is missing", [checkedFields[j]]),
	}
}

CxPolicy[result] {
	ver := input.document[i].resource.aws_s3_bucket[name].versioning
	ver[checkedFields[j]] != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning.%s", [name, checkedFields[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is equal 'true'", [checkedFields[j]]),
		"keyActualValue": sprintf("'%s' is equal to 'false'", [checkedFields[j]]),
	}
}
