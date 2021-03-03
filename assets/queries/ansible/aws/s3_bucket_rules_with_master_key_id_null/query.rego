package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3_bucket := task["amazon.aws.s3_bucket"]
	encryption := s3_bucket.encryption

	encryption != "AES256"
	not s3_bucket.encryption_key_id

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{amazon.aws.s3_bucket}}.encryption", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.s3_bucket.encryption_key_id is defined",
		"keyActualValue": "amazon.aws.s3_bucket.encryption_key_id is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3_bucket := task["amazon.aws.s3_bucket"]
	encryption := s3_bucket.encryption

	encryption != "AES256"
	ansLib.checkValue(s3_bucket)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{amazon.aws.s3_bucket}}.encryption", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "amazon.aws.s3_bucket.encryption_key_id is defined",
		"keyActualValue": "amazon.aws.s3_bucket.encryption_key_id is empty or null",
	}
}
