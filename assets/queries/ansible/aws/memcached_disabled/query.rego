package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  task["community.aws.elasticache"].engine == "redis"

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.elasticache}}.engine", [task.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.elasticache}}.engine enables Memcached", [task.name]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.elasticache}}.engine doesn't enable Memcached", [task.name])
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
