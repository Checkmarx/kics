package generic.ansible

tasks := TasksPerDocument

TasksPerDocument[id] = result {
	document := input.document[i]
	id := document.id
	result := getTasks(document)
}

getTasks(document) = result {
	document.playbooks[0].tasks
	result := [task |
		playbook := document.playbooks[0].tasks[_]
		task := getTasksFromBlocks(playbook)[_]
	]
} else = result {
	result := [task |
		playbook := document.playbooks[_]
		task := getTasksFromBlocks(playbook)[_]
	]
}

getTasksFromBlocks(playbook) = result {
	playbook.block
	result := [task |
		walk(playbook, [path, task])
		is_object(task)
		not task.block
		validPath(path)
	]
} else = [playbook] {
	true
}

validPath(path) {
	count(path) > 1
	validGroup(path[minus(count(path), 2)])
}

validGroup("block") = true

validGroup("always") = true

validGroup("rescue") = true

checkState(task) {
	state := object.get(task, "state", "undefined")
	state != "absent"
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}

isAnsibleFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}

checkValue(val) {
	count(val) == 0
}

checkValue(val) {
	val == null
}

check_database_flags_content(database_flags, flagName, flagValue) {
	database_flags[x].name == flagName
	database_flags[x].value != flagValue
}

check_database_flags_content(database_flags, flagName, flagValue) {
	database_flags.name == flagName
	database_flags.value != flagValue
}

allowsPort(allowed, port) {
	portNumber := to_number(port)
	some i
	contains(allowed.ports[i], "-")
	port_bounds := split(allowed.ports[i], "-")
	low := port_bounds[0]
	high := port_bounds[1]
	isPortInBounds(low, high, portNumber)
} else {
	allowed.ports[_] == port
} else = false {
	true
}

isPortInBounds(low, high, portNumber) {
	to_number(low) <= portNumber
	to_number(high) >= portNumber
} else = false {
	true
}

checkPortIsOpen(rule, portNumber) {
	rule.from_port != -1
	rule.from_port <= portNumber
	rule.to_port >= portNumber
}

checkPortIsOpen(rule, portNumber) {
	rule.ports == portNumber
}

checkPortIsOpen(rule, portNumber) {
	rule.ports[_] == portNumber
}

checkPortIsOpen(rule, portNumber) {
	mports := split(rule.ports, "-")
	to_number(mports[0]) <= portNumber
	to_number(mports[1]) >= portNumber
}

checkPortIsOpen(rule, portNumber) {
	mports := split(rule.ports[_], "-")
	to_number(mports[0]) <= portNumber
	to_number(mports[1]) >= portNumber
}

checkPortIsOpen(rule, portNumber) {
	rule.from_port == -1
}

checkPortIsOpen(rule, portNumber) {
	rule.to_port == -1
}
