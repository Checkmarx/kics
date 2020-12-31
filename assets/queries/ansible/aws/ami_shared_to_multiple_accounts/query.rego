package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]

    amiIsShared(task["amazon.aws.ec2_ami"].launch_permissions)
    
    result := {
        "documentId":        document.id,
        "searchKey":         sprintf("name=%s.{{amazon.aws.ec2_ami}}.launch_permissions", [task.name]),
        "issueType":         "IncorrectValue",
        "keyExpectedValue":  "amazon.aws.ec2_ami.launch_permissions just allows one user to launch the AMI",
        "keyActualValue": 	 "amazon.aws.ec2_ami.launch_permissions allows more than one user to launch the AMI"
    }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

amiIsShared(attribute) = allow {
    attribute.group_names
	allow = true
}

amiIsShared(attribute) = allow {
    count(attribute.user_ids) > 1
	allow = true
}