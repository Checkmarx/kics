package Cx


CxPolicy [ result ] {
  resource := input.document[i].resource.aws_kms_key[name]
  
  resource.is_enabled == true
  
  resource.enable_key_rotation == true
  
  not resource.deletion_window_in_days


  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_kms_key[%s]", [name]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   sprintf("aws_kms_key[%s].deletion_window_in_days is set and valid", [name]),
                "keyActualValue": 	  sprintf("aws_kms_key[%s].deletion_window_in_days is undefined", [name]),
            }
}




CxPolicy [ result ] {
  resource := input.document[i].resource.aws_kms_key[name]
  
  resource.is_enabled == true
  
  resource.enable_key_rotation == true
  
  resource.deletion_window_in_days > 30


  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_kms_key[%s].deletion_window_in_days", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("aws_kms_key[%s].deletion_window_in_days is set and valid", [name]),
                "keyActualValue": 	  sprintf("aws_kms_key[%s].deletion_window_in_days is set but invalid", [name]),
            }
}



CxPolicy [ result ] {
  resource := input.document[i].resource.aws_kms_key[name]
  
  resource.is_enabled == true
  
  resource.enable_key_rotation == true
  
  resource.deletion_window_in_days < 7


  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_kms_key[%s].deletion_window_in_days", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("aws_kms_key[%s].deletion_window_in_days is set and valid", [name]),
                "keyActualValue": 	  sprintf("aws_kms_key[%s].deletion_window_in_days is set but invalid", [name]),
            }
}
