package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_instance[name]
  
  not resource.vpc_security_group_ids
  


  result := {
                "documentId": 		   input.document[i].id,
                "searchKey": 	       sprintf("aws_instance[%s].vpc_security_group_ids", [name]),
                "issueType":		     "MissingAttribute",
                "keyExpectedValue":  "Attribute 'vpc_security_group_ids' is defined",
                "keyActualValue": 	 "Attribute 'vpc_security_group_ids' is undefined"
            }
}
