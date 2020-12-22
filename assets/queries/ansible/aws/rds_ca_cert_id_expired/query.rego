package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    object.get(task["community.aws.rds_instance"], "ca_certificate_identifier", "undefined") == "undefined"
    
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{community.aws.rds_instance}}", [task.name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "RDS instance ca_certificate_identifier should be defined",
        "keyActualValue": "RDS instance ca_certificate_identifier is undefined"
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    task["community.aws.rds_instance"].ca_certificate_identifier != "rds-ca-2019"
    
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{community.aws.rds_instance}}.ca_certificate_identifier", [task.name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": ".publicly_accessible is false",
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
