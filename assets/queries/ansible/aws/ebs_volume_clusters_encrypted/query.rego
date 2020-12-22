package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  volume := task["amazon.aws.ec2_vol"]
  volumeName := task.name

  object.get(volume, "encrypted", "undefined") == "undefined"


  result := {
              "documentId":       input.document[i].id,
              "searchKey":        sprintf("name={{%s}}.{{amazon.aws.ec2_vol}}", [volumeName]),
              "issueType":        "MissingAttribute",
              "keyExpectedValue": "amazon.aws.ec2_vol.encrypted should be set to true",
              "keyActualValue":   "amazon.aws.ec2_vol.encrypted is undefined"
            }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  volume := task["amazon.aws.ec2_vol"]
  volumeName := task.name

  not isAnsibleTrue(volume.encrypted)

  result := {
              "documentId":       input.document[i].id,
              "searchKey":        sprintf("name={{%s}}.{{amazon.aws.ec2_vol}}.encrypt", [volumeName]),
              "issueType":        "WrongValue",
              "keyExpectedValue": "amazon.aws.ec2_vol.encrypted should be set to true",
              "keyActualValue":   "amazon.aws.ec2_vol.encrypted is set to false"
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