package Cx


isSSH(currentFromPort, currentToPort) = allow {
     currentFromPort == 22
     currentToPort == 22
     allow = true
}




isPrivate(cidr) = allow {
     privateIPs = ["192.120.0.0/16", "75.132.0.0/16", "79.32.0.0/8", "73.16.0.0/12"]
     
     cidrLength := count(cidr)
     
     count({x | cidr[x]; cidr[x] == privateIPs[j]}) == cidrLength
     
     allow = true
}




CxPolicy [ result ] {
  resource := input.document[i].resource.aws_security_group[name].ingress
  currentFromPort := resource.from_port
  currentToPort := resource.to_port
  cidr := resource.cidr_blocks
  
  isSSH(currentFromPort, currentToPort)
  
  not isPrivate(cidr)
  

  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("aws_security_group[%s].ingress.cidr", [name]),
                "issueType":		     "IncorrectValue",
                "keyExpectedValue":   sprintf("aws_security_group[%s].ingress.cidr is not public", [name]),
                "keyActualValue": 	  sprintf("aws_security_group[%s].ingress.cidr is public", [name]),
            }
}