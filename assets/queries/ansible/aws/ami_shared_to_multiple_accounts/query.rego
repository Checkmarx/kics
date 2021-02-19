package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.ec2_ami"].publicly_accessible)
	amiIsShared(task["amazon.aws.ec2_ami"].launch_permissions)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_ami}}.launch_permissions", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "amazon.aws.ec2_ami.launch_permissions just allows one user to launch the AMI",
		"keyActualValue": "amazon.aws.ec2_ami.launch_permissions allows more than one user to launch the AMI",
	}
}

amiIsShared(attribute) = allow {
	attribute.group_names
	allow = true
}

amiIsShared(attribute) = allow {
	count(attribute.user_ids) > 1
	allow = true
}
