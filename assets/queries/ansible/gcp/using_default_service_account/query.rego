package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name
  instance.auth_kind == "serviceaccount"

  object.get(instance, "service_account_email", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}", [instanceName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.service_account_email is defined",
                "keyActualValue":   "google.cloud.gcp_compute_instance.service_account_email is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name
  instance.auth_kind == "serviceaccount"
  email := instance.service_account_email
  
  is_string(email)
  count(email) == 0

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.service_account_email", [instanceName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.service_account_email is not empty",
                "keyActualValue":   "google.cloud.gcp_compute_instance.service_account_email is empty"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name
  instance.auth_kind == "serviceaccount"
  email := instance.service_account_email

  is_string(email)
  count(email) > 0
  not contains(email, "@")

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.service_account_email", [instanceName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.service_account_email is an email",
                "keyActualValue":   "google.cloud.gcp_compute_instance.service_account_email is not an email"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name
  instance.auth_kind == "serviceaccount"
  email := instance.service_account_email

  contains(email, "@developer.gserviceaccount.com")

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.service_account_email", [instanceName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.service_account_email is not a default Google Compute Engine service account",
                "keyActualValue":   "google.cloud.gcp_compute_instance.service_account_email is a default Google Compute Engine service account"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}