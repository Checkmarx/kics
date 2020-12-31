package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  task["community.aws.cloudfront_distribution"].default_cache_behavior.viewer_protocol_policy == "allow-all"

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy", [task.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy is 'https-only' or 'redirect-to-https'", [task.name]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy 'isn't https-only' or 'redirect-to-https'", [task.name])
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  task["community.aws.cloudfront_distribution"].cache_behaviors.viewer_protocol_policy == "allow-all"

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy", [task.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy is 'https-only' or 'redirect-to-https'", [task.name]),
                "keyActualValue": 	sprintf("name=%s.{{community.aws.cloudfront_distribution}}.cache_behaviors.viewer_protocol_policy 'isn't https-only' or 'redirect-to-https'", [task.name])
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
