package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  cloudfrontDistribution := task["community.aws.cloudfront_distribution"]

  cloudfrontDistribution.default_cache_behavior.viewer_protocol_policy = "allow-all"

  result := {
                "documentId":       document.id,
                "searchKey":        sprintf("name={{%s}}.{{community.aws.cloudfront_distribution}}.default_cache_behavior.viewer_protocol_policy", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'default_cache_behavior.viewer_protocol_policy' is equal 'https-only'",
                "keyActualValue": 	"'default_cache_behavior.viewer_protocol_policy' is equal 'allow-all'"
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
