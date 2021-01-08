package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    
    object.get(task["community.aws.aws_codebuild"], "encryption_key", "undefined") == "undefined"
    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{community.aws.aws_codebuild}}", [task.name]),
        "issueType":         "MissingAttribute",
        "keyExpectedValue":  "community.aws.aws_codebuild.encryption_key is set",
        "keyActualValue": 	 "community.aws.aws_codebuild.encryption_key is undefined"
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}
