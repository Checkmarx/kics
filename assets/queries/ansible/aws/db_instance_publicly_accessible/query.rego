package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    isAnsibleTrue(task["community.aws.rds_instance"].publicly_accessible)
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{community.aws.rds_instance}}.publicly_accessible", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("module's parameter community.aws.rds_instance.publicly_accessible should be false in task: '%s'", [task.name]),
        "keyActualValue": sprintf("module's parameter community.aws.rds_instance.publicly_accessible is true in task: '%s'", [task.name])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    isAnsibleTrue(task["community.aws.rds"].publicly_accessible)
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{community.aws.rds}}.publicly_accessible", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("module's parameter community.aws.rds.publicly_accessible should be false in task: '%s'", [task.name]),
        "keyActualValue": sprintf("module's parameter community.aws.rds.publicly_accessible is true in task: '%s'", [task.name])
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

isAnsibleTrue(answer) {
    lower(answer) == "yes"
} else {
    lower(answer) == "true"
} else {
    answer == true
}
