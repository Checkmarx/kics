package Cx

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroupIngress"
    
    properties := resource.Properties
    
    properties.CidrIp == "0.0.0.0/0"


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties.CidrIp", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.CidrIp is not open to the world", [name]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.CidrIp is open to the world", [name])
              }
}

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroupIngress"
    
    properties := resource.Properties
    
    properties.CidrIpv6 == "::/0"


    result := {
                "documentId": 		   input.document[i].id,
                "searchKey": 	       sprintf("Resources.%s.Properties.CidrIpv6", [name]),
                "issueType":		     "IncorrectValue",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.CidrIpv6 is not open to the world", [name]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.CidrIpv6 is open to the world", [name])
              }
}

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroup"
    
    properties := resource.Properties
    
    properties["SecurityGroupIngress"][index].CidrIp == "0.0.0.0/0"


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties.SecurityGroupIngress.CidrIp", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp is not open to the world", [name, index]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIp is open to the world", [name, index])
              }
}

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroup"
    
    properties := resource.Properties
    
    properties["SecurityGroupIngress"][index].CidrIpv6 == "::/0"


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties.SecurityGroupIngress.CidrIpv6", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6 is not open to the world", [name, index]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.SecurityGroupIngress[%d].CidrIpv6 is open to the world", [name, index])
              }
}