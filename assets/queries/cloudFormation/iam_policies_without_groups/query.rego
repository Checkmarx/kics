package Cx

CxPolicy [result] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::IAM::Policy"
  users := resource.Properties.Policies[_].Users
  users != []
  users != null
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.Policies.Users", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'Resources.Properties.Policies.Users should be replaced by Groups",
                "keyActualValue": 	"'Resources.Properties.Policies.Users' is not the correct definition."
             }
}