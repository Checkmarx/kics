package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

rds := {"community.aws.rds_instance", "rds_instance"}

sgs := {"community.aws.rds_subnet_group", "rds_subnet_group"}

sbs := {"amazon.aws.ec2_vpc_subnet", "ec2_vpc_subnet"}

options := {"db_subnet_group_name", "subnet_group"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	instance := task[rds[r]]
	ans_lib.checkState(instance)

	# get subnet group name
	subnetGroupName := instance[options[o]]

	# get subnet group
	tk := ans_lib.tasks[_][_]
	sg := tk[sgs[_]]
	ans_lib.checkState(sg)
	sg.name == subnetGroupName

	# get subnets info
	subnets := sg.subnets

	# verify if some subnet is public
	is_public(subnets)

	result := {
		"documentId": id,
		"resourceType": rds[r],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s", [task.name, rds[r], options[o]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "RDS should not be running in a public subnet",
		"keyActualValue": "RDS is running in a public subnet",
		"searchLine": common_lib.build_search_line(["playbooks", t, rds[r], options[o]], []),
	}
}

unrestricted_cidr(sb) {
	sb.cidr == "0.0.0.0/0"
} else {
	sb.ipv6_cidr == "::/0"
}


is_public(subnets) {
	subnet := subnets[_]
	subnetNameUnclean := split(subnet, ".")[0]
	subnetNameHalfClean := replace(subnetNameUnclean, " ", "")
	subnetNameClean := replace(subnetNameHalfClean, "{{", "")

	tk := ans_lib.tasks[_][_]
	sb := tk[sbs[_]]
	ans_lib.checkState(sb)

	tk.register == subnetNameClean
	unrestricted_cidr(sb)
}
