package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    modules := {"community.aws.ec2_lc", "ec2_lc"}
    
    object.get(task[modules[index]], "volumes", "undefined") == "undefined"

    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name={{%s}}.{{%s}}", [task.name, modules[index]]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  sprintf("%s.volumes is set", [modules[index]]),
        "keyActualValue": 	 sprintf("%s.volumes is undefined", [modules[index]])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    modules := {"community.aws.ec2_lc", "ec2_lc"}
    
    object.get(task[modules[index]].volumes[j], "encrypted", "undefined") == "undefined"

    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name={{%s}}.{{%s}}.volumes", [task.name, modules[index]]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  sprintf("%s.volumes[%d].encrypted is set", [modules[index], j]),
        "keyActualValue": 	 sprintf("%s.volumes[%d].encrypted is undefined", [modules[index], j])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    modules := {"community.aws.ec2_lc", "ec2_lc"}
    
    object.get(task[modules[index]].volumes[j], "ephemeral", "undefined") == "undefined"
    isNoOrFalse(task[modules[index]].volumes[j].encrypted)

    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name={{%s}}.{{%s}}.volumes", [task.name, modules[index]]),
        "issueType":         "IncorrectValue",
        "keyExpectedValue":  sprintf("%s.volumes[%d].encrypted is set to true or yes", [modules[index], j]),
        "keyActualValue": 	 sprintf("%s.volumes[%d].encrypted is not set to true or yes", [modules[index], j])
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}

isNoOrFalse(attribute) = allow {
    possibilities := {"no", false}
    attribute == possibilities[j]
    
	allow = true
}