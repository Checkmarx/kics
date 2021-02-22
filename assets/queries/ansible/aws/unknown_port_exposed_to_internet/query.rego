package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	currentPort := task["amazon.aws.ec2_group"].rules[index].from_port

	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	not portIsKnown(currentPort)
	isEntireNetwork(cidr)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon.aws.ec2_group.rules[%d].from_port is known", [index]),
		"keyActualValue": sprintf("amazon.aws.ec2_group.rules[%d].from_port is unknown and is exposed to the entire Internet", [index]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	currentPort := task["amazon.aws.ec2_group"].rules[index].from_port

	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ipv6

	not portIsKnown(currentPort)
	isEntireNetwork(cidr)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon.aws.ec2_group.rules[%d].from_port is known", [index]),
		"keyActualValue": sprintf("amazon.aws.ec2_group.rules[%d].from_port is unknown and is exposed to the entire Internet", [index]),
	}
}

portIsKnown(port) = allow {
	knownPorts := [
		0, 20, 21, 22, 23, 25, 53, 57, 80, 88, 110, 119, 123, 135, 143, 137, 138, 139,
		161, 162, 163, 164, 194, 318, 443, 514, 563, 636, 989, 990, 1433, 1434,
		2382, 2383, 2484, 3000, 3020, 3306, 3389, 4505, 4506, 5060, 5353, 5432,
		5500, 5900, 7001, 8000, 8080, 8140, 9000, 9200, 9300, 11214, 11215, 27017,
		27018, 61621,
	]

	count({x | knownPorts[x]; knownPorts[x] == port}) != 0

	allow = true
}

isEntireNetwork(cidr) = allow {
	isArray := is_array(cidr)

	cidrs = {"0.0.0.0/0", "::/0"}

	count({x | cidr[x]; cidr[x] == cidrs[j]}) != 0

	allow = true
}

isEntireNetwork(cidr) = allow {
	isString := is_string(cidr)

	cidrs = {"0.0.0.0/0", "::/0"}
	cidr == cidrs[j]

	allow = true
}
