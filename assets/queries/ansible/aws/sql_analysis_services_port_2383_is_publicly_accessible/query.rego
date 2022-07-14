package Cx

import data.generic.ansible as ansLib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.ec2_group", "ec2_group"}
	ec2_group := task[modules[m]]
	ansLib.checkState(ec2_group)

	rule := ec2_group.rules[index]
	rule.cidr_ip == "0.0.0.0/0"
	rule.proto == "tcp"
	ansLib.isPortInRule(rule, 2383)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ec2_group.rules[%d] shouldn't open the SQL analysis services port (2383)", [index]),
		"keyActualValue": sprintf("ec2_group.rules[%d] opens the SQL analysis services port (2383)", [index]),
	}
}
