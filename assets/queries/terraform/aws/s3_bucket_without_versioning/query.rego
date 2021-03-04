package Cx

#default of mfa_delete is false
CxPolicy[result] {
	b := input.document[i].resource.aws_s3_bucket[name]
    object.get(b,"versioning","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' is equal 'true'",
		"keyActualValue": "'versioning' is missing",
	}
}

#default of enabled is false
CxPolicy[result] {
	b := input.document[i].resource.aws_s3_bucket[name]
	object.get(b.versioning, "enabled", "not found") == "not found"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning.enabled' is equal 'true'",
		"keyActualValue": "'versioning.enabled' is missing",
	}
}

CxPolicy[result] {
	v := input.document[i].resource.aws_s3_bucket[name].versioning
	v.enabled != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].versioning.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning' is equal 'true'",
		"keyActualValue": "'versioning' is equal 'false'",
	}
}
