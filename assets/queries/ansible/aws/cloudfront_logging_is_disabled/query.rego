package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    cloudfront := task["community.aws.cloudfront_distribution"]
    object.get(cloudfront, "logging", "undefined") == "undefined"
    
 
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}", [task.name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}} logging is defined", [task.name]), 
        "keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}} logging is undefined", [task.name])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    cloudfront := task["community.aws.cloudfront_distribution"]
    loggingE := cloudfront.logging
    not isAnsibleTrue(loggingE.enabled)
    
 
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.logging.enabled", [task.name2]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.logging.enabled is true", [task.name2]), 
        "keyActualValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.logging.enabled is false", [task.name2])
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
