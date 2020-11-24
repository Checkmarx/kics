package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_role[name]
  out := json.unmarshal(resource.assume_role_policy)
  statements := out.Statement[_]
  statements.Action[_] == "*"
  statements.Effect == "Allow"
  statements.Resource == "*"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [statements.Action]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "'assume_role_policy.Statement.Action' doesn't contain '*'",
                "keyActualValue": 	"'assume_role_policy.Statement.Action' contains '*'"    
              }
}
