package Cx

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    validate_json(policy)
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    pol.Statement[idx].Principal = "*"
	checkAction(pol.Statement[idx].Action)

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Action", [pl[r], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s[%s].policy.Action is not a 'Write_ACP' action", [pl[r], name]),
                "keyActualValue": 	sprintf("%s[%s].policy.Action is a 'Write_ACP' action", [pl[r], name])
              }
}

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    validate_json(policy)
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    contains(pol.Statement[idx].Principal.AWS, "*")
	checkAction(pol.Statement[idx].Action)

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Action", [pl[r], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s[%s].policy.Action is not a 'Write_ACP' action", [pl[r], name]),
                "keyActualValue": 	sprintf("%s[%s].policy.Action is a 'Write_ACP' action", [pl[r], name])
              }
}

validate_json(string) = true {
	not startswith(string, "$")
}

checkAction(action) = true {
	is_string(action)
	contains(lower(action), "write_acp")
}

checkAction(action) = true {
	is_array(action)
	contains(lower(action[_]), "write_acp")
}