package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  ad := task["azure_ad_serviceprincipal"]
  adName := task.name
  
  ad.ad_user
  is_string(ad.ad_user)
  count(ad.ad_user) == 0

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_ad_serviceprincipal}}.ad_user", [adName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_ad_serviceprincipal.ad_user is not empty",
                "keyActualValue":   "azure_ad_serviceprincipal.ad_user is empty"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  ad := task["azure_ad_serviceprincipal"]
  adName := task.name
  
  ad.ad_user == null

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_ad_serviceprincipal}}.ad_user", [adName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_ad_serviceprincipal.ad_user is not null",
                "keyActualValue":   "azure_ad_serviceprincipal.ad_user is null"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  ad := task["azure_ad_serviceprincipal"]
  adName := task.name
  
  is_string(ad.ad_user)
  check_predictable(ad.ad_user)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_ad_serviceprincipal}}.ad_user", [adName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_ad_serviceprincipal.ad_user is not predictable",
                "keyActualValue":   "azure_ad_serviceprincipal.ad_user is predictable"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}

check_predictable (name) {
	predictable_names := {"admin", "administrator", "sqladmin", "root", "user", "azure_admin", "azure_administrator", "guest"}
	some i
    	predictable_names[i] == lower(name)
}
