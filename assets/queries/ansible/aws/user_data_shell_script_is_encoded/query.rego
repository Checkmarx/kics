package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  user_data := task["community.aws.ec2_lc"].user_data
  decode_result := check_user_data(user_data)
  startswith(decode_result, "#!/")

  result := {
          "documentId": document.id,
          "searchKey": "{{community.aws.ec2_lc}}.user_data",
          "issueType": "IncorrectValue",
          "keyExpectedValue": sprintf("name=%s.{{community.aws.ec2_lc}}.user_data is not shell script", [task.name]),
          "keyActualValue": sprintf("name=%s.{{community.aws.ec2_lc}}.user_data is shell script", [task.name]),
      }
}

getTasks(document) = result {
  result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
  count(result) != 0
} else = result {
  result := [body | playbook := document.playbooks[_]; body := playbook ]
  count(result) != 0
}

check_user_data(user_data) = result {
	user_data == null
  result := base64.decode("dGVzdA==") #test
}

check_user_data(user_data) = result {
	user_data != null
  result := base64.decode(user_data)
}
