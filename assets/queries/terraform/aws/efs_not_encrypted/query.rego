package Cx

CxPolicy [ result ] {

  efs := input.document[i].resource.aws_efs_file_system[name]
  not efs.encrypted
  
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_efs_file_system[%s]", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("aws_efs_file_system[%s].encrypted' is true", [name]),
                "keyActualValue": sprintf("aws_efs_file_system[%s].encrypted' is false", [name])
              }
}

