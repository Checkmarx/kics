package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    modules := {"community.aws.sts_assume_role", "sts_assume_role"}
    
    attributes := {"mfa_serial_number", "mfa_token"}
     
    object.get(task[modules[index]], attributes[j], "undefined") == "undefined"

    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  sprintf("%s.%s is set", [modules[index], attributes[j]]),
        "keyActualValue": 	 sprintf("%s.%s is undefined", [modules[index], attributes[j]])
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}