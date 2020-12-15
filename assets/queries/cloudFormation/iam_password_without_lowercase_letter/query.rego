package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  password := resource.Properties.LoginProfile.Password
  not regex.match(".*[a-z]", password) 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'Resources.Properties.LoginProfile.Password' contains lowercase letter",
                "keyActualValue": 	"'Resources.Properties.LoginProfile.Password' doesn't contain lowercase letter"
              }
}