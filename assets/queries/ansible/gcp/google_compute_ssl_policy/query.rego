package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  policy := task["google.cloud.gcp_compute_ssl_policy"]
  policyName := task.name

  object.get(policy, "min_tls_version", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_ssl_policy}}", [policyName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_compute_ssl_policy should have a min_tls_version 'TLS_1_2'",
                "keyActualValue":   "google.cloud.gcp_compute_ssl_policy does not have min_tls_version 'TLS_1_2'"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  policy := task["google.cloud.gcp_compute_ssl_policy"]
  policyName := task.name
  policy.min_tls_version != "TLS_1_2"
  

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_ssl_policy}}.min_tls_version", [policyName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_ssl_policy.min_tls_version should have min_tls_version 'TLS_1_2'",
                "keyActualValue":   "google.cloud.gcp_compute_ssl_policy.min_tls_version does not have min_tls_version 'TLS_1_2'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
