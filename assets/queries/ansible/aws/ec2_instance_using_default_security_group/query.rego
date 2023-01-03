package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ans_lib.checkState(ec2)

	sgs := {"group", "group_id"}

	is_array(ec2[sgs[s]])
	sgName := ec2[sgs[s]][idx]

	contains(lower(sgName), "default")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], sgs[s]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should not be using default security group", [sgs[s]]),
		"keyActualValue":  sprintf("'%s' is using default security group", [sgs[s]]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], sgs[s]], [idx]),
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ans_lib.checkState(ec2)

	sgs := {"group", "group_id"}

	is_string(ec2[sgs[s]])
	sgName := ec2[sgs[s]]

	contains(lower(sgName), "default")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], sgs[s]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should not be using default security group", [sgs[s]]),
		"keyActualValue":  sprintf("'%s' is using default security group", [sgs[s]]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], sgs[s]], []),
	}
}

