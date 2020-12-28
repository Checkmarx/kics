package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}
    
    object.get(task[modules[index]], "validate_certs", "undefined") == "undefined"

    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  sprintf("%s.validate_certs is set", [modules[index]]),
        "keyActualValue": 	 sprintf("%s.validate_certs is undefined", [modules[index]])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}
    
    not isTrueOrYes(task[modules[index]].validate_certs)

    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{%s}}.validate_certs", [task.name, modules[index]]),
        "issueType":         "IncorrectValue",
        "keyExpectedValue":  sprintf("%s.validate_certs is set to yes", [modules[index]]),
        "keyActualValue": 	 sprintf("%s.validate_certs is not set to yes", [modules[index]])
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}

isTrueOrYes(attribute) = allow {
    possibilities := {"yes", true}
    attribute == possibilities[j]
    
	allow = true
}