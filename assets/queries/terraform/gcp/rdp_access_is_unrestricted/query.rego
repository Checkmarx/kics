package Cx

CxPolicy [ result ] {
  firewall := input.document[i].resource.google_compute_firewall[name]
  
  isDirIngress(firewall)
  allowed := getAllowed(firewall)
  isRDPport(allowed[_])

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_firewall[%s].allow.ports", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("'google_compute_firewall[%s].allow.ports' does not include RDP port 3389", [name]),
                "keyActualValue": 	sprintf("'google_compute_firewall[%s].allow.ports' includes RDP port 3389", [name])
              }
}

getAllowed(firewall) = allowed {
  is_array(firewall.allow)
  allowed := firewall.allow
}

getAllowed(firewall) = allowed {
 is_object(firewall.allow)
 allowed := [firewall.allow]
}

isDirIngress(firewall) = true {
  firewall.direction == "INGRESS"
}

isDirIngress(firewall) = true {
  not firewall.direction
}

isRDPport(allow) = true {
  isTCPorUDP(allow.protocol)
  some j
    contains(allow.ports[j],"-")
    port_bounds := split(allow.ports[j],"-")
    low_bound := to_number(port_bounds[0])
    high_bound := to_number(port_bounds[1])
    isInBounds(low_bound,high_bound)
}

isRDPport(allow) = true {
  isTCPorUDP(allow.protocol)
  some j
    contains(allow.ports[j],"-") == false
    to_number(allow.ports[j]) == 3389
}

isInBounds(low,high) = true {
  low <= 3389
  high >= 3389
}

isTCPorUDP(protocol) = true {
  lower(protocol) == "tcp"
}

isTCPorUDP(protocol) = true {
  lower(protocol) == "udp"
}