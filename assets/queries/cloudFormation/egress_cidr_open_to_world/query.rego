package Cx

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroupEgress"
    
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
    resource.Type == "AWS::EC2::SecurityGroupEgress"
    
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
    
    properties["SecurityGroupEgress"][index].CidrIp == "0.0.0.0/0"


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties.SecurityGroupEgress.CidrIp", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIp is not open to the world", [name, index]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIp is open to the world", [name, index])
              }
}

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroup"
    
    properties := resource.Properties
    
    properties["SecurityGroupEgress"][index].CidrIpv6 == "::/0"


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties.SecurityGroupEgress.CidrIpv6", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIpv6 is not open to the world", [name, index]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].CidrIpv6 is open to the world", [name, index])
              }
}