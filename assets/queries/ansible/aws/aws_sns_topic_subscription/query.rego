package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  snsTopicCommunity := task["community.aws.sns_topic"]
  snsTopicName := task.name
  object.get(snsTopicCommunity, "subscriptions", "undefined") != "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.sns_topic}}", [snsTopicName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "community.aws.sns_topic.subscriptions should be undefined",
                "keyActualValue": "community.aws.sns_topic.subscriptions is defined"
              }
}


CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  snsTopic := task["sns_topic"]
  snsTopicName := task.name
  object.get(snsTopic, "subscriptions", "undefined") != "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{sns_topic}}", [snsTopicName]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "sns_topic.subscriptions should be undefined",
                "keyActualValue": "sns_topic.subscriptions is defined"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}
