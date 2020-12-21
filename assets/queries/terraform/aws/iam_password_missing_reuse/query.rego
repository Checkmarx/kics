package Cx

CxPolicy [ result ] {
  password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
  object.get(password_policy, "password_reuse_prevention", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s]", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "'password_reuse_prevention' should be set with value 24",
                "keyActualValue": 	"'password_reuse_prevention' is undefined"
              }
}

CxPolicy [ result ] {
  password_policy := input.document[i].resource.aws_iam_account_password_policy[name]
  rp := password_policy.password_reuse_prevention
  rp < 24

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].password_reuse_prevention", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'password_reuse_prevention' should be 24",
                "keyActualValue": 	"'password_reuse_prevention' is lower than 24"
              }
}