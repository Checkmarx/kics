package Cx

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroupEgress"
    
    properties := resource.Properties
    
    properties.FromPort != properties.ToPort


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties.FromPort", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.FromPort is equal to Resources.%s.Properties.ToPort", [name, name]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.FromPort is not equal to Resources.%s.Properties.ToPort", [name, name])
              }
}

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroup"
    
    properties := resource.Properties
    
    properties["SecurityGroupEgress"][index].FromPort != properties["SecurityGroupEgress"][index].ToPort


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties.SecurityGroupEgress.FromPort", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].FromPort is equal to Resources.%s.Properties.SecurityGroupEgress[%d].ToPort", [name, index, name, index]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.SecurityGroupEgress[%d].FromPort is not equal to Resources.%s.Properties.SecurityGroupEgress[%d].ToPort", [name, index, name, index])
              }
}