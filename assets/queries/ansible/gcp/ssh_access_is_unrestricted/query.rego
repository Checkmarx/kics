package Cx

CxPolicy [result] {
  playbooks := getTasks(input.document[i])
  firewall := playbooks[j]
  instance := firewall["google.cloud.gcp_compute_firewall"]

  isDirIngress(instance)

  instance.source_ranges[_] == "0.0.0.0/0" #Allow traffic ingressing from anywhere

  allowed := instance.allowed

  allowsSSHPort(allowed[k])

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports", [playbooks[j].name,allowed[k].ip_protocol]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports don't contain SSH port (22) with unrestricted ingress traffic", [playbooks[j].name,allowed[k].ip_protocol]),
                "keyActualValue": 	sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports contain SSH port (22) with unrestricted ingress traffic", [playbooks[j].name,allowed[k].ip_protocol])
              }
}

isDirIngress(instance) {
  instance.direction == "INGRESS"
} else {
  not instance.direction
} else = false

allowsSSHPort(allowed) {
  some i
    contains(allowed.ports[i],"-")
    port_bounds := split(allowed.ports[i],"-")
    low := port_bounds[0]
    high := port_bounds[1]
    isSSHInBounds(low,high)
} else {
  allowed.ports[_] == "22"
} else = false

isSSHInBounds(low,high) {
  to_number(low) <= 22
  to_number(high) >= 22
} else = false

getTasks(document) = result {
  result := document.playbooks[0].tasks
} else = result {
  object.get(document.playbooks[0],"tasks","undefined") == "undefined"
  result := document.playbooks
}