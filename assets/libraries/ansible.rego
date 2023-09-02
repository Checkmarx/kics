package generic.ansible

# Global variable with all tasks in input
tasks := TasksPerDocument

# Builds an object that stores all tasks for each document id
TasksPerDocument[id] = result {
	document := input.document[i]
	id := document.id
	result := getTasks(document)
}

# Function used to get all tasks from a document
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

# Function used to get all nested tasks inside a block task ("block", "always", "rescue")
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

# Validates the path of a nested element inside a block task to assure it's a task
validPath(path) {
	count(path) > 1
	validGroup(path[minus(count(path), 2)])
}

# Identifies a block task
validGroup("block") = true

validGroup("always") = true

validGroup("rescue") = true

# Checks if a task is not an absent task
checkState(task) {
	state := object.get(task, "state", "undefined")
	state != "absent"
}

# Checks if a variable has 'true' value in Ansible
isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}

# Checks if a variable has 'false' value in Ansible
isAnsibleFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
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
	low := to_number(port_bounds[0])
	high := to_number(port_bounds[1])

	low <= portNumber
	high >= portNumber
} else {
	allowed.ports[_] == port
} else = false {
	true
}

# Checks if a given port is included in a network rule
isPortInRule(rule, portNumber) {
	rule.from_port != -1
	rule.from_port <= portNumber
	rule.to_port >= portNumber
}

isPortInRule(rule, portNumber) {
	rule.ports == portNumber
}

isPortInRule(rule, portNumber) {
	rule.ports[_] == portNumber
}

isPortInRule(rule, portNumber) {
	mports := split(rule.ports, "-")
	to_number(mports[0]) <= portNumber
	to_number(mports[1]) >= portNumber
}

isPortInRule(rule, portNumber) {
	mports := split(rule.ports[_], "-")
	to_number(mports[0]) <= portNumber
	to_number(mports[1]) >= portNumber
}

isPortInRule(rule, portNumber) {
	rule.from_port == -1
}

isPortInRule(rule, portNumber) {
	rule.to_port == -1
}

# Checks if CIDR represents entire network
isEntireNetwork(cidr) {
	is_array(cidr)
	cidrs = {"0.0.0.0/0", "::/0"}
	count({x | cidr[x]; cidr[x] == cidrs[j]}) != 0
}

isEntireNetwork(cidr) {
	is_string(cidr)
	cidrs = {"0.0.0.0/0", "::/0"}
	cidr == cidrs[j]
}

installer_modules := [
	"community.general.apk", "ansible.builtin.apt", "ansible.builtin.apt", "community.general.bundler", "ansible.builtin.dnf", "community.general.easy_install", 
	"community.general.gem", "community.general.homebrew", "community.general.jenkins_plugin", "community.general.npm", "community.general.openbsd_pkg", 
	"ansible.builtin.package", "ansible.builtin.package", "community.general.pear", "community.general.pacman", "ansible.builtin.pip", "community.general.pkg5", 
	"community.general.pkgutil", "community.general.pkgutil", "community.general.portage", "community.general.slackpkg", "community.general.sorcery", 
	"community.general.swdepot", "win_chocolatey", "community.general.yarn", "ansible.builtin.yum", "community.general.zypper", "apk", "apt", "bower", "bundler", 
	"dnf", "easy_install", "gem", "homebrew", "jenkins_plugin", "npm", "openbsd_package", "openbsd_pkg", "package", "pacman", "pear", "pip", "pkg5", "pkgutil", 
	"portage", "slackpkg", "sorcery", "swdepot", "win_chocolatey", "yarn", "yum", "zypper",
]