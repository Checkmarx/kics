package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  bucket := task["amazon.aws.aws_s3"]
  bucketName := task.name
  
  checkDelete(bucket.mode)
  contains(bucket.permission, "public")

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{amazon.aws.aws_s3}}", [bucketName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "amazon.aws.aws_s3 does not allow Delete Action From All Principals",
                "keyActualValue":   "amazon.aws.aws_s3 allows Delete Action From All Principals"
              }
}

checkDelete(mode) {
  contains(mode, "delete")
}

checkDelete(mode) {
  contains(mode, "delobj")
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}