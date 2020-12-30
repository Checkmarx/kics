package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  server := task["azure_rm_sqlserver"]
  serverName := task.name
  
  checkSize(server.admin_username)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_rm_sqlserver}}.admin_username", [serverName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_rm_sqlserver.admin_username is not empty",
                "keyActualValue":   "azure_rm_sqlserver.admin_username is empty"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  server := task["azure_rm_sqlserver"]
  serverName := task.name
  
  is_string(server.admin_username)
  check_predictable(server.admin_username)

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{azure_rm_sqlserver}}.admin_username", [serverName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azure_rm_sqlserver.admin_username is not predictable",
                "keyActualValue":   "azure_rm_sqlserver.admin_username is predictable"
              }
}

checkSize(username){
  is_string(username)
  count(username) == 0
}

checkSize(username){
  username == null
}

check_predictable(username){
  predictable_names := {"admin", "administrator", "root", "user", "azure_admin", "azure_administrator", "guest"}
	some i
    	lower(username) == predictable_names[i]
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}