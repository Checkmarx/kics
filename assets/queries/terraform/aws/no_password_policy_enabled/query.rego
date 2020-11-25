package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_user_login_profile[name]

  not resource.password_length

  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_iam_user_login_profile[%s]", [name]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   "Attribute 'password_length' is set",
                "keyActualValue": 	  "Attribute 'password_length' is undefined"
            }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_user_login_profile[name]

  not resource.password_reset_required

  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_iam_user_login_profile[%s]", [name]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   "Attribute 'password_reset_required' is set",
                "keyActualValue": 	  "Attribute 'password_reset_required' is undefined"
            }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_user_login_profile[name]
  
  resource.password_length < 14

  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_iam_user_login_profile[%s]", [name]),
                "issueType":		      "MissingAttribute, IncorrectValue",
                "keyExpectedValue":   "Attribute 'password_length' is 14 or grater",
                "keyActualValue": 	  "Attribute 'password_length' is smaller than 14"
            }
}