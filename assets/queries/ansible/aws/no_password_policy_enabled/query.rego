package Cx


CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    modules := {"community.aws.iam_password_policy", "iam_password_policy"}
    
    count({index | object.get(task, modules[index], "undefined") == "undefined"}) == 2


    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s", [task.name]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  "community.aws.iam_password_policy or iam_password_policy is set",
        "keyActualValue": 	 "community.aws.iam_password_policy or iam_password_policy is not set",
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    modules := {"community.aws.iam_password_policy", "iam_password_policy"}
    
    attributes := {"require_lowercase", "require_numbers", "require_symbols", "require_uppercase"}

    object.get(task[modules[index]], attributes[j], "undefined") == "undefined"


    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{%s}}", [task.name, modules[index]]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  sprintf("%s.%s is set", [modules[index], attributes[j]]),
        "keyActualValue": 	 sprintf("%s.%s is undefined", [modules[index], attributes[j]])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    modules := {"community.aws.iam_password_policy", "iam_password_policy"}
    
    attributes := {"require_lowercase", "require_numbers", "require_symbols", "require_uppercase"}

    attribute := object.get(task[modules[index]], attributes[j], "undefined")
    attribute != "undefined"
    
    not isTrueOrYes(attribute)

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

isTrueOrYes(attribute) = allow {
    possibilities := {"yes", true}
    attribute == possibilities[j]
    
	allow = true
}