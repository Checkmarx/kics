package Cx

CxPolicy [ result ] {
  password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
  object.get(password_policy, "require_symbols", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s]", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "'require_symbols' should be set with true value",
                "keyActualValue": 	"'require_symbols' is undefined"
              }
}

CxPolicy [ result ] {
  password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
  password_policy.require_symbols == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].require_symbols", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'require_symbols' should be true",
                "keyActualValue": 	"'require_symbols' is false"
              }
}