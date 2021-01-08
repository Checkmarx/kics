package Cx

CxPolicy [result ]  {
	document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  https_value := task["azure_rm_webapp"].https_only

  not HasHttpsEnabled(https_value)

  result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{azure_rm_webapp}}.https_only", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "{{azure_rm_webapp}}.https_only is set to true or 'yes'",
        "keyActualValue": sprintf("{{azure_rm_webapp}}.https_only value is '%s'", [https_value])
          }
}

CxPolicy [result ]  {
	document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
	https := task["azure_rm_webapp"]

  object.get(https, "https_only", "undefined") == "undefined"

  result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{azure_rm_webapp}}", [task.name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("name=%s.{{azure_rm_webapp}}.https_only is defined", [task.name]),
        "keyActualValue": sprintf("name=%s.{{azure_rm_webapp}}.https_only is undefined", [task.name])
		  }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook]
    count(result) != 0
}

HasHttpsEnabled(value) {
	lower(value) == "yes"
} else {
	  lower(value) == "true"
} else {
	  value == true
}
