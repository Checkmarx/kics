
package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    retainStack := task["amazon.aws.cloudformation"]
    object.get( retainStack, "retain_stack", "undefined") == "undefined"


    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{amazon.aws.cloudformation}}", [task.name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("name=%s.{{amazon.aws.cloudformation}} retain_stack is defined", [task.name]),
        "keyActualValue": sprintf("name=%s.{{amazon.aws.cloudformation}} retain_stack is undefined", [task.name])
    }
}

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    retainStack := task["amazon.aws.cloudformation"]
    retainstack := retainStack.retain_stack
    not isAnsibleTrue(retainstack)


    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{amazon.aws.cloudformation}}.retain_stack", [task.name2]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("name=%s.{{amazon.aws.cloudformation}}.retain_stack is true", [task.name2]),
        "keyActualValue": sprintf("name=%s.{{amazon.aws.cloudformation}}.retain_stack is false", [task.name2])
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
