package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  bucket := task["google.cloud.gcp_storage_bucket"]
  bucketName := task.name

  object.get(bucket, "acl", "undefined") == "undefined"
  object.get(bucket, "default_object_acl", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_storage_bucket}}", [bucketName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_storage_bucket.default_object_acl is defined",
                "keyActualValue":   "google.cloud.gcp_storage_bucket.default_object_acl is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  bucket := task["google.cloud.gcp_storage_bucket"]
  bucketName := task.name
  bucket.acl
  check(bucket.acl.entity)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_storage_bucket}}.acl.entity", [bucketName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_storage_bucket.acl.entity isn't 'allUsers' or 'allAuthenticatedUsers'",
                "keyActualValue":   "google.cloud.gcp_storage_bucket.acl.entity is 'allUsers' or 'allAuthenticatedUsers'"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  bucket := task["google.cloud.gcp_storage_bucket"]
  bucketName := task.name
  object.get(bucket, "acl", "undefined") == "undefined"
  bucket.default_object_acl
  check(bucket.default_object_acl.entity)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_storage_bucket}}.default_object_acl.entity", [bucketName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_storage_bucket.default_object_acl.entity isn't 'allUsers' or 'allAuthenticatedUsers'",
                "keyActualValue":   "google.cloud.gcp_storage_bucket.default_object_acl.entity is 'allUsers' or 'allAuthenticatedUsers'"
              }
}

check(entity){
  is_string(entity)
  lower(entity) == "allusers"
}

check(entity){
  is_string(entity)
  lower(entity) == "allauthenticatedusers"
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}