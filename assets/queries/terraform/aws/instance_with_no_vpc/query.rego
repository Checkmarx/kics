package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_instance[name]
  
  not resource.vpc_security_group_ids
  


  result := {
                "documentId": 		   input.document[i].id,
                "searchKey": 	       sprintf("aws_instance[%s]", [name]),
                "issueType":		     "MissingAttribute",
                "keyExpectedValue":  "Attribute 'vpc_security_group_ids' is set",
                "keyActualValue": 	 "Attribute 'vpc_security_group_ids' is undefined"
            }
}
