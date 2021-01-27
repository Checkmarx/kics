package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::ElasticLoadBalancing::LoadBalancer"
  resource.Properties.Listeners[_].InstanceProtocol != "HTTPS"
  resource.Properties.Listeners[_].Protocol != "HTTPS"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Listeners", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Listeners is setup with SSL", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Listeners isn't setup with SSL", [name]),
              }
}
