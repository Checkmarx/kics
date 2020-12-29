package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  gcpBucket := task["google.cloud.gcp_storage_bucket"]
  bucketName := task.name
  registerName := task.register
  not containsBucket(registerName)
  
  

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.register", [bucketName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_storage_bucket.register has same name has 'bucket_access_control'",
                "keyActualValue":   "google.cloud.gcp_storage_bucket.register does not have the same name has 'bucket_access_control'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}

containsBucket(string) = true {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  gcpBucket := task["google.cloud.gcp_storage_bucket_access_control"]
  contains(gcpBucket.bucket,string)
} else = false {true}
