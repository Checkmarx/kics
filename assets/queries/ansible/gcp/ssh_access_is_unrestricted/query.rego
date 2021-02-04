package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_compute_firewall"]

	ansLib.checkState(instance)
	ansLib.isDirIngress(instance)

	instance.source_ranges[_] == "0.0.0.0/0" #Allow traffic ingressing from anywhere

	allowed := instance.allowed

	ansLib.allowsPort(allowed[k], "22")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports", [task.name, allowed[k].ip_protocol]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports don't contain SSH port (22) with unrestricted ingress traffic", [task.name, allowed[k].ip_protocol]),
		"keyActualValue": sprintf("name=%s.{{google.cloud.gcp_compute_firewall}}.allowed.ip_protocol=%s.ports contain SSH port (22) with unrestricted ingress traffic", [task.name, allowed[k].ip_protocol]),
	}
}
