package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  min_version_string = "4.0.10"
  eval_version_number(task["community.aws.elasticache"].cache_engine_version) < eval_version_number(min_version_string)

    result := {
                "documentId": 		  input.document[i].id,
                "searchKey":        sprintf("name=%s.{{community.aws.elasticache}}.cache_engine_version", [task.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.elasticache}}.cache_engine_version is compliant with the requirements", [task.name]),
                "keyActualValue":   sprintf("name=%s.{{community.aws.elasticache}}.cache_engine_version isn't compliant with the requirements", [task.name])
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}

eval_version_number(engine_version) = numeric_version {
	version = split(engine_version, ".")
	numeric_version = to_number(version[0]) * 100 + to_number(version[1]) * 10 + to_number(version[2])
}
