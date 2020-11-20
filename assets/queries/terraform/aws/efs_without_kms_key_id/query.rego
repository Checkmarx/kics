package Cx

CxPolicy [ result ] {

  efs= input.document[i].resource.aws_efs_file_system[name]
  not efs.kms_key_id
  
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_efs_file_system[%s]", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": "'aws_efs_file_system.kms_key_id' is 'defined'",
                "keyActualValue": 	"'aws_efs_file_system.kms_key_id' is 'undefined'"
              }
}