package Cx


CxPolicy [ result ] {

  resource := input.document[i].resource.aws_ami_launch_permission[name]
  
  account_id:= resource.account_id
  
  image_id := resource.image_id
  
  
  launchPermissions:= { "123456789012": ["ami-12345678", "ami-12345679", "ami-12345680"],
                        "23456789018": ["ami-12345678", "ami-12345679"],
                        "23456782322": ["ami-12345619", "ami-12345645"],
                      }


  images = object.get(launchPermissions, account_id, "not found")
  
  images == "not found"
  
  
   result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_ami_launch_permission[%s]", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   "Attribute 'account_id' has launch permission for the Attribute 'image_id'",
                "keyActualValue": 	  "Attribute 'account_id' has not launch permission at all"
            }
}





CxPolicy [ result ] {

  resource := input.document[i].resource.aws_ami_launch_permission[name]
  
  account_id:= resource.account_id
  
  image_id := resource.image_id
  
  
  launchPermissions:= { "123456789012": ["ami-12345678", "ami-12345679", "ami-12345680"],
                        "23456789018": ["ami-12345678", "ami-12345679"],
                        "23456782322": ["ami-12345619", "ami-12345645"],
                      }


  images = object.get(launchPermissions, account_id, "not found")
  
  images != "not found"
  
  count({x | images[x]; images[x] == image_id }) == 0
  
   result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_ami_launch_permission[%s]", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   "Attribute 'account_id' has launch permission for the Attribute 'image_id'",
                "keyActualValue": 	  "Attribute 'account_id' has not launch permission for the attribute 'image_id'"
            }
}



