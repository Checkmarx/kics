package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ans_lib.checkState(ec2)

	sgs := {"group", "group_id"}

	sgName := get_name(ec2[sgs[s]])

	contains(lower(sgName), "default")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, modules[m], sgs[s]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is not using default security group", [sgs[s]]),
		"keyActualValue":  sprintf("'%s' is using default security group", [sgs[s]]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], sgs[s]], []),
	}
}

get_name(group) = name {
	is_array(group)
	name := group[g]
} else = name {
	is_string(group)
	name := group
}
