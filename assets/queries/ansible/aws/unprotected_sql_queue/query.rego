package Cx

CxPolicy [ result ] {
  document = input.document[i]
  tasks := getTasks(document)
  sqsQueuePolicy = tasks[_]
  sqsQueueBody = sqsQueuePolicy["community.aws.sqs_queue"]
  sqsQueueName = sqsQueuePolicy.name
  object.get(sqsQueueBody,"state","present")== "present"

  not sqsQueueBody.kms_master_key_id
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name={{%s}}.{{community.aws.sqs_queue}}.kms_master_key_id", [sqsQueueName]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'kms_master_key_id' should be set",
                "keyActualValue": 	"'kms_master_key_id' is undefined"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
