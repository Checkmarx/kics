package Cx

CxPolicy [ result ] {
  	document := input.document[i]
  	task := getTasks(document)[t]
    s3_bucket := task["amazon.aws.s3_bucket"]

    s3_bucket.encryption == "none"

	  result := {
                "documentId": 		document.id,
                "searchKey":        sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.encryption", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("aws_s3_bucket.encryption is %s",  [s3_bucket.encryption]),
                "keyActualValue": 	"aws_s3_bucket.encryption is none",
              }
}

getTasks(document) = result {
  result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
  count(result) != 0
} else = result {
  result := [body | playbook := document.playbooks[_]; body := playbook ]
  count(result) != 0
}
