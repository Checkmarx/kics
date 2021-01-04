package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  bucket := task["amazon.aws.s3_bucket"]
  bucketName := task.name
  
  contains(lower(bucket.policy.Statement[_].Action), "list")
  bucket.policy.Statement[_].Principal == "*"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.policy.Statement", [bucketName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "amazon.aws.s3_bucket does not allow List Action From All Principals",
                "keyActualValue":   "amazon.aws.s3_bucket allows List Action From All Principals"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}