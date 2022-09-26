package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib


CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ans_lib.checkState(ec2)

	subnetNameUnclean := split(ec2.vpc_subnet_id, ".")[0]
	subnetNameHalfClean := replace(subnetNameUnclean, " ", "")
	subnetNameClean := replace(subnetNameHalfClean, "{{", "")

	sbs := {"amazon.aws.ec2_vpc_subnet", "ec2_vpc_subnet"}
	tk := ans_lib.tasks[_][_]
	sb := tk[sbs[_]]
	ans_lib.checkState(sb)

	tk.register == subnetNameClean

	contains(lower(sb.vpc_id), "default")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.vpc_subnet_id", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'vpc_subnet_id' should not be associated with a default VPC",
		"keyActualValue":  "'vpc_subnet_id' is associated with a default VPC",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "vpc_subnet_id"], []),
	}
}
