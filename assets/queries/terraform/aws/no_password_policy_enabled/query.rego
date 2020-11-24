package Cx



CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_user_login_profile[name]
  
  
  not resource.password_length
  not resource.password_reset_required 
  


  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_iam_user_login_profile[%s]", [name]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   "Both attribute 'password_length' and 'password_reset_required' are set",
                "keyActualValue": 	  "Both attribute 'password_length' and 'password_reset_required' are undefined"
            }
}






CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_user_login_profile[name]
  
  not resource.password_length
  resource.password_reset_required == true
  
  
  


  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_iam_user_login_profile[%s]", [name]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   "Attribute 'password_length' is set and attribute 'password_reset_required' is true",
                "keyActualValue": 	  "Attribute 'password_length' is not set and attribute 'password_reset_required' is true"
            }
}




CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_user_login_profile[name]
  
  not resource.password_reset_required
  resource.password_length < 14
  
  


  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_iam_user_login_profile[%s]", [name]),
                "issueType":		      "MissingAttribute, IncorrectValue",
                "keyExpectedValue":   "Attribute 'password_length' is 14 or grater and attribute 'password_reset_required' is true",
                "keyActualValue": 	  "Attribute 'password_length' is smaller than 14 and attribute 'password_reset_required' is undefined or false"
            }
}



CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_user_login_profile[name]
  
  resource.password_reset_required == true
  resource.password_length < 14
  
  


  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_iam_user_login_profile[%s].password_length", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   "Attribute 'password_length' is 14 or grater and attribute 'password_reset_required' is true",
                "keyActualValue": 	  "Attribute 'password_length' is smaller than 14 and attribute 'password_reset_required' is true"
            }
}





CxPolicy [ result ] {
  resource := input.document[i].resource.aws_iam_user_login_profile[name]
  
  not resource.password_reset_required
  resource.password_length >= 14
  
  

  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_iam_user_login_profile[%s]", [name]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   "Attribute 'password_length' is 14 or greater and attribute 'password_reset_required' is true",
                "keyActualValue": 	  "Attribute 'password_length' is 14 or greater and attribute 'password_reset_required' is undefined or false",
            }
}