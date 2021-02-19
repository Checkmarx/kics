package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	s3_bucket := task["amazon.aws.s3_bucket"]
	encryption := s3_bucket.encryption

	encryption != "AES256"
	not s3_bucket.encryption_key_id

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.s3_bucket}}.encryption", [tasks[t].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.s3_bucket.encryption_key_id is defined",
		"keyActualValue": "amazon.aws.s3_bucket.encryption_key_id is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	s3_bucket := task["amazon.aws.s3_bucket"]
	encryption := s3_bucket.encryption

	encryption != "AES256"
	check_key_id(s3_bucket)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.s3_bucket}}.encryption", [tasks[t].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "amazon.aws.s3_bucket.encryption_key_id is defined",
		"keyActualValue": "amazon.aws.s3_bucket.encryption_key_id is empty or null",
	}
}

check_key_id(bucket) {
	bucket.encryption_key_id == ""
}

check_key_id(bucket) {
	bucket.encryption_key_id == null
}

