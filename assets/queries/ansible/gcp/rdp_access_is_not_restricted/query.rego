package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_compute_firewall", "gcp_compute_firewall"}
	instance := task[modules[m]]
	ansLib.checkState(instance)

	isDirIngress(instance)

	allowed := instance.allowed
	ansLib.allowsPort(allowed[k], "3389")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.allowed.ip_protocol=%s.ports", [task.name, modules[m], allowed[k].ip_protocol]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_compute_firewall.allowed.ip_protocol=%s.ports don't contain RDP port (3389) with unrestricted ingress traffic", [allowed[k].ip_protocol]),
		"keyActualValue": sprintf("gcp_compute_firewall.allowed.ip_protocol=%s.ports contain RDP port (3389) with unrestricted ingress traffic", [allowed[k].ip_protocol]),
	}
}

isDirIngress(instance) {
	instance.direction == "INGRESS"
} else {
	not instance.direction
} else = false {
	true
}
