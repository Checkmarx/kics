package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
     
    task["amazon.aws.s3_bucket"].encryption == "none"

    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{amazon.aws.s3_bucket}}.encryption", [task.name]),
        "issueType":         "IncorrectValue",
        "keyExpectedValue":  "amazon.aws.s3_bucket.encryption is not none",
        "keyActualValue": 	 "amazon.aws.s3_bucket.encryption is none"
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}