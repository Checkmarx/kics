package Cx

CxPolicy [ result ] {
  document := input.document[i]
  task := getTasks(document)[t]

  access := task["google.cloud.gcp_bigquery_dataset"].access
	lower(access[_].special_group) == "allauthenticatedusers"
    
	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_bigquery_dataset}}.access", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'access.special_group' is not equal to 'allAuthenticatedUsers'",
                "keyActualValue": 	"'access.special_group' is equal to 'allAuthenticatedUsers'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}