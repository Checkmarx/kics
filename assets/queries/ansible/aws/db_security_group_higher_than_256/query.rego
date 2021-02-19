package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	instanceList := tasks[_]
	ec2_instance = instanceList.ec2_group
	ec2_instanceName = ec2_instance.name
	count(ec2_instance.rules) > 0
	elements := {elem | elem := ec2_instance.rules[j]; checkOver256(ec2_instance.rules[j].cidr_ip)}
	count(elements) > 0
	values := concat(",", {e | e := elements[p].cidr_ip; true})
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.rules.cidr_ip", [ec2_instanceName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'name={{%s}}.rules.cidr_ip' is one of [10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12]", [ec2_instanceName]),
		"keyActualValue": sprintf("'name={{%s}}.rules.cidr_ip' is [%s]", [ec2_instanceName, values]),
	}
}

checkOver256(ipVal) {
	hosts := split(ipVal, "/")
	to_number(hosts[1]) <= 24
}


