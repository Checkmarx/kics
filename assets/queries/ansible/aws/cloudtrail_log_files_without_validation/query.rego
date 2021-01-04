package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    modules := {"community.aws.cloudtrail", "cloudtrail"}
    
    object.get(task[modules[index]], "enable_log_file_validation", "undefined") == "undefined"
    object.get(task[modules[index]], "log_file_validation_enabled", "undefined") == "undefined"
    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  sprintf("%s.enable_log_file_validation or %s.log_file_validation_enabled is set", [modules[index], modules[index]]),
        "keyActualValue": 	 sprintf("%s.enable_log_file_validation and %s.log_file_validation_enabled are undefined", [modules[index], modules[index]])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    modules := {"community.aws.cloudtrail", "cloudtrail"}
    
    attributes := {"enable_log_file_validation", "log_file_validation_enabled"}
    
    attr := object.get(task[modules[index]], attributes[j], "undefined")
    attr != "undefined"
    not isYesOrTrue(attr)
    
    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{%s}}.%s", [task.name, modules[index], attributes[j]]),
        "issueType":         "IncorrectValue",
        "keyExpectedValue":  sprintf("%s.%s is set to true or yes", [modules[index], attributes[j]]),
        "keyActualValue": 	 sprintf("%s.%s is not set to true or yes", [modules[index], attributes[j]])
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}

isYesOrTrue(attribute) {
	options := {"yes", true}
	attribute == options[j]
}
