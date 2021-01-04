package Cx

CxPolicy [result] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::IAM::User"
  loginProfile := resource.Properties.LoginProfile
  loginProfile.Password
  loginProfile.PasswordResetRequired == false
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.LoginProfile.PasswordResetRequired", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.LoginProfile.PasswordResetRequired' should be configured as true",[name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.LoginProfile.PasswordResetRequired' is configured as false",[name])
              }
}
CxPolicy [result] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::IAM::User"
  loginProfile := resource.Properties
  object.get(loginProfile, "LoginProfile", "undefined") == "undefined"
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties' should be configured with LoginProfile with PasswordResetRequired property set to true",[name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties' does not include LoginProfile",[name])
              }
}
CxPolicy [result] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::IAM::User"
  passwordResetRequired := resource.Properties.LoginProfile
  count(passwordResetRequired) == 1
  passwordResetRequired.Password
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.LoginProfile", [name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.LoginProfile' should also include PasswordResetRequired property set to true",[name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.LoginProfile' contains only Password property",[name])
              }
}