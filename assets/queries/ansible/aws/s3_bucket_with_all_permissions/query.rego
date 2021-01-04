package Cx

CxPolicy [ result ] {
  	document := input.document[i]
  	task := getTasks(document)[t]
    s3_bucket := task["s3_bucket"]

    policy := s3_bucket.policy
    json_policy := json.unmarshal(policy)
    json_policy.Statement[ix].Effect = "Allow"

    action := json_policy.Statement[ix].Action
    is_string(action)
    contains(action[_], "*")

	result := {
                "documentId": 		document.id,
                "searchKey":        sprintf("name={{%s}}.{{s3_bucket}}.policy", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Action' contains '*'",
              }
}

CxPolicy [ result ] {
  	document := input.document[i]
  	task := getTasks(document)[t]
    s3_bucket := task["s3_bucket"]

    policy := s3_bucket.policy
    json_policy := json.unmarshal(policy)
    json_policy.Statement[ix].Effect = "Allow"

    action := json_policy.Statement[ix].Action
    is_array(action)
    contains(action[_], "*")

	result := {
                "documentId": 		document.id,
                "searchKey":        sprintf("name={{%s}}.{{s3_bucket}}.policy", [task.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Action' contains '*'",
              }
}

getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]
    count(result) != 0
}
