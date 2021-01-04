package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  disk := task["google.cloud.gcp_compute_disk"]
  diskName := task.name
  
  object.get(disk, "disk_encryption_key", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_disk}}", [diskName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_compute_disk.disk_encryption_key is defined",
                "keyActualValue":   "google.cloud.gcp_compute_disk.disk_encryption_key is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  disk := task["google.cloud.gcp_compute_disk"]
  diskName := task.name
  
  object.get(disk.disk_encryption_key, "raw_key", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_disk}}.disk_encryption_key", [diskName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_compute_disk.disk_encryption_key.raw_key is defined",
                "keyActualValue":   "google.cloud.gcp_compute_disk.disk_encryption_key.raw_key is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  disk := task["google.cloud.gcp_compute_disk"]
  diskName := task.name
  
  check(disk.disk_encryption_key.raw_key)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_disk}}.disk_encryption_key.raw_key", [diskName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_disk.disk_encryption_key.raw_key is not empty or null",
                "keyActualValue":   "google.cloud.gcp_compute_disk.disk_encryption_key.raw_key is empty or null"
              }
}

check(key){
  key == null
}

check(key){
  count(key) == 0
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}
