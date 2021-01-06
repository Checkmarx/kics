package Cx

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  firewall := playbooks[j]
  instance := firewall["google.cloud.gcp_compute_firewall"]

  isDirIngress(instance)

  allowed := instance.allowed
  allowsRDP(allowed[k])

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports", [playbooks[j].name,allowed[k].ip_protocol]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports don't contain RDP port (3389) with unrestricted ingress traffic", [playbooks[j].name,allowed[k].ip_protocol]),
                "keyActualValue": 	sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports contain RDP port (3389) with unrestricted ingress traffic", [playbooks[j].name,allowed[k].ip_protocol])
              }
}

isDirIngress(instance) {
  instance.direction == "INGRESS"
} else {
  not instance.direction
} else = false

allowsRDP(allowed) {
  some i
    contains(allowed.ports[i],"-")
    port_bounds := split(allowed.ports[i],"-")
    low := port_bounds[0]
    high := port_bounds[1]
    isRDPInBounds(low,high)
} else {
  allowed.ports[_] == "3389"
} else = false

isRDPInBounds(low,high) {
  to_number(low) <= 3389
  to_number(high) >= 3389
} else = false

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}