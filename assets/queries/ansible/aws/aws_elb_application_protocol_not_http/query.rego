package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  applicationLb := task["community.aws.elb_application_lb"]
  clusterName := applicationLb.name

  applicationLb.listeners[index].Protocol != "HTTPS"


  result := {
                "documentId":       document.id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.elb_application_lb}}.listeners.Protocol=%s", [task.name, applicationLb.listeners[index].Protocol]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "'aws_elb_application_lb' Protocol should be 'HTTP'",
                "keyActualValue":   "'aws_elb_application_lb' Protocol it's not 'HTTP'"
              }
}

CxPolicy [ result ] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    applicationLb := task["community.aws.elb_application_lb"]
    clusterName := applicationLb.name

    applicationLb.listeners[index]
    not MissingProtocol(applicationLb.listeners)

  result := {
                "documentId":       document.id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.elb_application_lb}}.listeners", [task.name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "'aws_elb_application_lb' Protocol should be 'HTTP'",
                "keyActualValue":   "'aws_elb_application_lb' Protocol is missing"
              }
}

MissingProtocol(listeners) = true {
	listeners[_].Protocol
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
