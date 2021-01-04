package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::VPC"

  gatewayAttachments := { gatewayAttachment | resource := input.document[_].Resources[_]
  										  	                    resource.Type == "AWS::EC2::VPCGatewayAttachment"
                                          	  refers(resource.Properties.VpcId, name)
                                          	  gatewayAttachment := resource }
  count(gatewayAttachments) > 3

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'Resources.%s' not attached with a number of gateways close to or out of limit", [name]),
                "keyActualValue": 	sprintf("'Resources.%s' attached with a number of gateways close to or out of limit", [name])
              }
}

refers(obj, name) {
	obj.Ref == name
}
refers(obj, name) {
	obj == name
}
