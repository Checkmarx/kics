package Cx

CxPolicy [result]  {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Subnet"
  map := resource.Properties.MapPublicIpOnLaunch
  checkState(map)
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.MapPublicIpOnLaunch", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' should be false",[name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.MapPublicIpOnLaunch' is true",[name])
              }
}
checkState(map) = true {
	map == true
}
