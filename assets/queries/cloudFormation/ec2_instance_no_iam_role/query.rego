package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Instance"
  
  object.get(resource.Properties,"IamInstanceProfile","undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' is set",[name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.IamInstanceProfile' is undefined",[name])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Instance"
  
  object.get(resource.Properties,"IamInstanceProfile","undefined") != "undefined"

  iamProfile := getIAMProfile(resource.Properties.IamInstanceProfile)

  emptyProfile(iamProfile)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.IamInstanceProfile",[name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.IamInstanceProfile' has matching IamInstanceProfile resource",[name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.IamInstanceProfile' does not have matching IamInstanceProfile resource",[name])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Instance"
  
  object.get(resource.Properties,"IamInstanceProfile","undefined") != "undefined"

  iamProfile := getIAMProfile(resource.Properties.IamInstanceProfile)

  emptyProfile(iamProfile) == false

  object.get(iamProfile[_].Properties,"Roles","undefined") == "undefined"

  some key
  iamProfile[key]

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties",[key]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.Roles' is set",[key]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.Roles' is undefined",[key])
              }
}

getIAMProfile(profileRef) = profile {
  is_string(profileRef)
  profile := {
    profileRef: object.get(input.document[0].Resources,profileRef,"undefined")
  }
} else = profile {
  is_object(profileRef)
  object.get(profileRef,"Ref","undefined") != "undefined"
  ref := object.get(profileRef,"Ref","undefined")
  profile := {
    ref: object.get(input.document[0].Resources, ref, "undefined")
  }
} else = {}

emptyProfile(iamProfile) = true {
  is_null(iamProfile)
} else = true {
  iamProfile[_] == "undefined"
} else = false
