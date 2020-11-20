package Cx


portIsKnown(port, knownPorts) = allow  {
    count({x | knownPorts[x]; knownPorts[x] == port}) != 0
    
    allow = true
}


isEntireNetwork(cidr) = allow {
       count({x | cidr[x]; cidr[x] == "0.0.0.0/0"}) != 0
           
       allow = true
}


CxPolicy [ result ] {
  resource := input.document[i].resource.aws_security_group[name].ingress
  currentPort := resource.from_port
  cidr := resource.cidr_blocks
  
  knownPorts := [8080, 443, 80, 57, 318]
  
  
  not portIsKnown(currentPort, knownPorts)
  isEntireNetwork(cidr)


  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_security_group[%s].ingress.from_port", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   sprintf("aws_security_group[%s].ingress.from_port is known", [name]),
                "keyActualValue": 	  sprintf("aws_security_group[%s].ingress.from_port is unknown and is exposed to the entire Internet", [name]),
            }
}