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
        "keyExpectedValue": "community.aws.rds_instance.publicly_accessible should be false",
        "keyActualValue": "community.aws.rds_instance.publicly_accessible.publicly_accessible is true"
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    isAnsibleTrue(task.rds.publicly_accessible)
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.rds.publicly_accessible", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "aws.rds.publicly_accessible should be false",
        "keyActualValue": "aws.rds.publicly_accessible is true"
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
        "keyExpectedValue": "community.aws.rds.publicly_accessible should be false",
        "keyActualValue": "community.aws.rds.publicly_accessible.publicly_accessible is true"
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
	answer == true
}
