package Cx


CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::NetworkAclEntry"

    properties := resource.Properties
    
    checkProtocol(properties.Protocol)
    
    object.get(properties, "PortRange", "undefined") == "undefined"


    result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("Resources.%s.Properties", [name]),
                "issueType":		    "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.PortRange is set", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.PortRange is undefined", [name])
              }
}

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::NetworkAclEntry"

    properties := resource.Properties
    
    checkProtocol(properties.Protocol)
    
    attributes := {"From", "To"}
    object.get(properties.PortRange, attributes[y], "undefined") == "undefined"


    result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("Resources.%s.Properties.PortRange", [name]),
                "issueType":		    "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.PortRange.%s is set", [name, y]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.PortRange.%s is undefined", [name, y])
              }
}

CxPolicy [ result ] {
    resource := input.document[i].Resources[name]
    resource.Type == "AWS::EC2::NetworkAclEntry"

    properties := resource.Properties
    checkProtocol(properties.Protocol)

    properties.PortRange.From == 0
    properties.PortRange.To == 65535

    result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("Resources.%s.Properties.PortRange", [name]),
                "issueType":		    "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.PortRange does not allow all ports", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.PortRange allows all ports", [name])
              }
}

checkProtocol(protocol) = allow {
    protocols := {6, 17}
    protocol == protocols[x]
    
	allow = true
}