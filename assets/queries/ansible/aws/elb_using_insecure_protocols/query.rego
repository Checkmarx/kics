package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.elb_network_lb", "elb_network_lb", "community.aws.elb_application_lb", "elb_application_lb"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	elb := task[modules[m]]
	ansLib.checkState(elb)

	object.get(elb, "listeners", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.listeners is defined", [modules[m]]),
		"keyActualValue": sprintf("%&s.listeners is undefined", [modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	elb := task[modules[m]]
	ansLib.checkState(elb)

	object.get(elb.listeners[j], "SslPolicy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.listeners.%s", [task.name, modules[m], j]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.listeners.SslPolicy is defined", [modules[m]]),
		"keyActualValue": sprintf("%s.listeners.SslPolicy is undefined", [modules[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	elb := task[modules[m]]
	ansLib.checkState(elb)

	check_vulnerability(elb.listeners[j].SslPolicy)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.listeners.%s", [task.name, modules[m], j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.listeners.SslPolicy is a secure protocol", [modules[m]]),
		"keyActualValue": sprintf("%s.listeners.SslPolicy is an insecure protocol", [modules[m]]),
	}
}

check_vulnerability(val) {
	insecure_protocols = {"Protocol-SSLv2", "Protocol-SSLv3", "Protocol-TLSv1", "Protocol-TLSv1.1"}
	val == insecure_protocols[_]
}
