package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.elb_application_lb", "elb_application_lb"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	applicationLb := task[modules[m]]
	ansLib.checkState(applicationLb)

	applicationLb.listeners[index].Protocol != "HTTPS"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.listeners.Protocol=%s", [task.name, modules[m], applicationLb.listeners[index].Protocol]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_elb_application_lb' Protocol should be 'HTTP'",
		"keyActualValue": "'aws_elb_application_lb' Protocol it's not 'HTTP'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	applicationLb := task[modules[m]]
	ansLib.checkState(applicationLb)

	applicationLb.listeners[index]
	not MissingProtocol(applicationLb.listeners)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.listeners", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_elb_application_lb' Protocol should be 'HTTP'",
		"keyActualValue": "'aws_elb_application_lb' Protocol is missing",
	}
}

MissingProtocol(listeners) {
	listeners[_].Protocol
}
