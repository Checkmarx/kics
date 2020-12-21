package Cx

CxPolicy [ result ] {
   document := input.document[i]
   tasks := getTasks(document)
   task := tasks[t]
   s3_bucket := task["amazon.aws.s3_bucket"]
   encryption := s3_bucket.encryption
   
   not encryption == "AES256"
   check_key_id(s3_bucket)

    result := {
            "documentId": document.id,
            "searchKey": sprintf("name=%s.{{amazon.aws.s3_bucket}}.encryption", [s3_bucket.name]),
            "issueType": "IncorrectValue",
            "keyExpectedValue": "amazon.aws.s3_bucket.encryption is AES256",
            "keyActualValue": sprintf("amazon.aws.s3_bucket.encryption is %s and encryption_key_id is empty or null", [encryption])
        }
}

check_key_id(bucket) {
	object.get(bucket, "encryption_key_id ", "undefined") == "undefined"
}

check_key_id(bucket) {
	bucket.encryption_key_id == ""
}

check_key_id(bucket) {
	bucket.encryption_key_id == null
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}
