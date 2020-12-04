package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_s3_bucket[name]
  policy := json_unmarshal(resource.policy)
  statement = policy.Statement[_]
  check_role(statement.Principal, "*") == true
  check_role(statement.Effect, "Allow") == true
  check_role(statement.Action, "*") == true
    
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("aws_s3_bucket[%s].policy", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("aws_s3_bucket[%s].policy doesn't make the bucket accessible to all AWS Accounts", [name]),
                "keyActualValue": 	sprintf("aws_s3_bucket[%s].policy does make the bucket accessible to all AWS Accounts", [name]),
              }
}

json_unmarshal(s) = result {
	s == null
	result := json.unmarshal("{}")
}

json_unmarshal(s) = result {
	s != null
	result := json.unmarshal(s)
}

check_role(s, p) = true {
    s == p
}