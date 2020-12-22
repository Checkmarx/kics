package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  storageAccount := task["amazon.aws.s3_bucket"]
  storageAccountName := task.name

  object.get(storageAccount, "versioning", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}", [storageAccountName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "amazon.aws.s3_bucket should have versioning set to true",
                "keyActualValue":   "amazon.aws.s3_bucket does not have versioning (defaults to false)"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  storageAccount := task["amazon.aws.s3_bucket"]
  storageAccountName := task.name
  not isAnsibleTrue(storageAccount.versioning)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.versioning", [storageAccountName]),
                "issueType":        "WrongValue",
                "keyExpectedValue": "amazon.aws.s3_bucket should have versioning set to true",
                "keyActualValue":   "amazon.aws.s3_bucket does has versioning set to false"
              }
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

isAnsibleTrue(answer) {
 	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}