package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    isAnsibleTrue(task["community.aws.redshift"].publicly_accessible)
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{community.aws.redshift}}.publicly_accessible", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "aws_redshift_cluster.publicly_accessible is false",
        "keyActualValue": "aws_redshift_cluster.publicly_accessible is true"
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    isAnsibleTrue(task.redshift.publicly_accessible)
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.redshift.publicly_accessible", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "aws_redshift_cluster.publicly_accessible is false",
        "keyActualValue": "aws_redshift_cluster.publicly_accessible is true"
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
