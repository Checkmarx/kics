package Cx

CxPolicy[ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  object.get(task["community.aws.route53"], "value", "undefined") == "undefined"

  result := {
      "documentId": document.id,
      "searchKey": sprintf("name=%s.{{community.aws.route53}}", [task.name]),
      "issueType": "MissingAttribute",
      "keyExpectedValue": "aws_route53.value is defined",
      "keyActualValue": "aws_route53.value is undefined"
  }
}

CxPolicy[ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  valueIsEmpty(task["community.aws.route53"].value)

  result := {
      "documentId": document.id,
      "searchKey": sprintf("name=%s.{{community.aws.route53}}.value", [task.name]),
      "issueType": "IncorrectValue",
      "keyExpectedValue": "aws_route53.value is not empty",
      "keyActualValue": "aws_route53.value is empty"
  }
}

getTasks(document) = result {
  result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
  count(result) != 0
} else = result {
  result := [body | playbook := document.playbooks[_]; body := playbook ]
  count(result) != 0
}

valueIsEmpty(value) {
	value == null
}
valueIsEmpty(value) {
	value != null
  count(value) <= 0
}
