package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  user_data := task["community.aws.ec2_lc"].user_data
  contains(user_data, "LS0tLS1CR")

  result := {
          "documentId": document.id,
          "searchKey": "{{community.aws.ec2_lc}}.user_data",
          "issueType": "IncorrectValue",
          "keyExpectedValue": sprintf("name=%s.{{community.aws.ec2_lc}}.user_data should not contain RSA Private Key", [task.name]),
          "keyActualValue": sprintf("name=%s.{{community.aws.ec2_lc}}.user_data contains RSA Private Key", [task.name]),
      }
}

getTasks(document) = result {
  result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
  count(result) != 0
} else = result {
  result := [body | playbook := document.playbooks[_]; body := playbook ]
  count(result) != 0
}
