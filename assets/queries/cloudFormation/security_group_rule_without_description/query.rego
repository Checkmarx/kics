package Cx

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroup"
    
    object.get(resource.Properties, "GroupDescription", "undefined") == "undefined"


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties", [name]),
                "issueType":          "MissingAttribute",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.GroupDescription is set", [name]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.GroupDescription is undefined", [name])
              }
}

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::SecurityGroup"

    properties := {"SecurityGroupIngress", "SecurityGroupEgress"}
    object.get(resource.Properties[properties[index]][j], "Description", "undefined") == "undefined"


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties.%s", [name, properties[index]]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.%s[%d].Description is set", [name, properties[index], j]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.%s[%d].Description is undefined", [name, properties[index], j])
              }
}

CxPolicy [ result ] {
    resourceTypes := {"AWS::EC2::SecurityGroupIngress", "AWS::EC2::SecurityGroupEgress"}
	  resource := input.document[i].Resources[name]
   
    resourceTypes[resource.Type]

    object.get(resource.Properties, "Description", "undefined") == "undefined"


    result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("Resources.%s.Properties", [name]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   sprintf("Resources.%s.Properties.Description is set", [name]),
                "keyActualValue": 	  sprintf("Resources.%s.Properties.Description is undefined", [name])
              }
}