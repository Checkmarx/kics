package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"amazon.aws.ec2_group", "ec2_group"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	ec2_instance = task[modules[m]]
	ans_lib.checkState(ec2_instance)

	rule := ec2_instance.rules[idx]
	
	cidrs := {"cidr_ip": "0.0.0.0/0", "cidr_ipv6" : "::/0"}

	cidrValue := cidrs[cidr]

	rule[cidr] == cidrValue

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rules.%s", [task.name, modules[m], cidr]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'ec2_group.rules.%s' should not be %s", [cidr, cidrValue]),
		"keyActualValue": sprintf("'ec2_group.rules.%s' is %s", [cidr, rule[cidr]]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "rules", idx, cidr], []),
	}
}
