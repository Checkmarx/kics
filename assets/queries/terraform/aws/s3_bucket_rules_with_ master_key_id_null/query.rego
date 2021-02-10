package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	ssec := resource.server_side_encryption_configuration[bucket]
	algorithm := ssec[ssecName]

	check_master_key(algorithm)
	not algorithm.sse_algorithm == "AES256"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("server_side_encryption_configuration.%s.%s.sse_algorithm", [bucket, ssecName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("server_side_encryption_configuration.%s.%s.sse_algorithm is AES256", [bucket, ssecName]),
		"keyActualValue": sprintf("server_side_encryption_configuration.%s.%s.sse_algorithm is %s", [bucket, ssecName, algorithm.sse_algorithm]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	ssec := resource.server_side_encryption_configuration[bucket]
	algorithm := ssec[ssecName]

	not check_master_key(algorithm)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("server_side_encryption_configuration.%s.%s.kms_master_key_id", [bucket, ssecName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("server_side_encryption_configuration.%s.%s.kms_master_key_id is undefined", [bucket, ssecName]),
		"keyActualValue": sprintf("server_side_encryption_configuration.%s.%s.kms_master_key_id is defined", [bucket, ssecName]),
	}
}

check_master_key(assed) {
	object.get(assed, "kms_master_key_id", "undefined") == "undefined"
}

check_master_key(assed) {
	assed.km_master_key_id == ""
}

check_master_key(assed) {
	assed.km_master_key_id == null
}
