package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name

  object.get(instance, "shielded_instance_config", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}", [instanceName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.shielded_instance_config is defined",
                "keyActualValue":   "google.cloud.gcp_compute_instance.shielded_instance_config is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name
  instance.shielded_instance_config
  object.get(instance.shielded_instance_config, "enable_integrity_monitoring", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config", [instanceName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.shielded_instance_config.enable_integrity_monitoring is defined",
                "keyActualValue":   "google.cloud.gcp_compute_instance.shielded_instance_config.enable_integrity_monitoring is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name
  instance.shielded_instance_config
  object.get(instance.shielded_instance_config, "enable_secure_boot", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config", [instanceName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.shielded_instance_config.enable_secure_boot is defined",
                "keyActualValue":   "google.cloud.gcp_compute_instance.shielded_instance_config.enable_secure_boot is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name
  instance.shielded_instance_config
  object.get(instance.shielded_instance_config, "enable_vtpm", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config", [instanceName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.shielded_instance_config.enable_vtpm is defined",
                "keyActualValue":   "google.cloud.gcp_compute_instance.shielded_instance_config.enable_vtpm is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name

  isAnsibleFalse(instance.shielded_instance_config.enable_integrity_monitoring)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_integrity_monitoring", [instanceName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.shielded_instance_config.enable_integrity_monitoring is true",
                "keyActualValue":   "google.cloud.gcp_compute_instance.shielded_instance_config.enable_integrity_monitoring is false"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name

  isAnsibleFalse(instance.shielded_instance_config.enable_secure_boot)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_secure_boot", [instanceName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.shielded_instance_config.enable_secure_boot is true",
                "keyActualValue":   "google.cloud.gcp_compute_instance.shielded_instance_config.enable_secure_boot is false"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  instance := task["google.cloud.gcp_compute_instance"]
  instanceName := task.name

  isAnsibleFalse(instance.shielded_instance_config.enable_vtpm)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.shielded_instance_config.enable_vtpm", [instanceName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "google.cloud.gcp_compute_instance.shielded_instance_config.enable_vtpm is true",
                "keyActualValue":   "google.cloud.gcp_compute_instance.shielded_instance_config.enable_vtpm is false"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
} 

isAnsibleFalse(answer) {
 	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}
