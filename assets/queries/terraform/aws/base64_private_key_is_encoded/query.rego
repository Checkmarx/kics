package Cx

CxPolicy [ result ] {
   resource := input.document[i].resource.aws_launch_configuration[name]
   user_data := resource.user_data_base64
   not user_data == null
   contains(user_data, "LS0tLS1CR")
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_launch_configuration[%s].user_data_base64", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("aws_launch_configuration[%s].user_data_base64 should not contain RSA Private Key", [name]),
                "keyActualValue": 	sprintf("aws_launch_configuration[%s].user_data_base64 contains RSA Private Key", [name] )
              }
}