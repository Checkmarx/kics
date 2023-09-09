package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][j]

	command := getRunCommand(resource)
	packages := [l | command[0] == pkg[l]]
	count(packages) > 0
	packageManager := pkg[packages[0]]
	install_position := getDetail(command, pkg_installer[packageManager][_])
	count(install_position) > 0

	update_data := getMinUpdateCommand(input.document[i], packageManager)
	not update_before(update_data, j, install_position)

	not checkException(packageManager, command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Instruction 'RUN %s %s' should be combined with 'RUN %s %s' ", [packageManager, pkg_installer[packageManager], packageManager, pkg_updater[packageManager]]),
		"keyActualValue": sprintf("Instruction 'RUN %s %s' isn't combined with 'RUN %s %s in the same 'RUN' statement", [packageManager, pkg_installer[packageManager], packageManager, pkg_updater[packageManager]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][j]

	command := getRunCommand(resource)
	packages := [l | command[0] == pkg[l]]
	count(packages) > 0
	packageManager := pkg[packages[0]]
	install_position := getDetail(command, pkg_installer[packageManager][_])
	count(install_position) > 0

	not getMinUpdateCommand(input.document[i], packageManager)
	not checkException(packageManager, command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Instruction 'RUN %s %s' should be combined with 'RUN %s %s'", [packageManager, pkg_installer[packageManager], packageManager, pkg_updater[packageManager]]),
		"keyActualValue": sprintf("Instruction 'RUN %s %s' isn't combined with 'RUN %s %s in the same 'RUN' statement", [packageManager, pkg_installer[packageManager], packageManager, pkg_updater[packageManager]]),
	}
}

getMinUpdateCommand(document, packageManager) = ans {
	ans := [x | x := {y: getUpdateCommand(document.command[_][y], packageManager)}][0]
}

getUpdateCommand(resource, packageManager) = ans {
	command := getRunCommand(resource)
	command[0] == packageManager
	position := getDetail(command, pkg_updater[packageManager][_])
	count(position) > 0
	ans := position
}

pkg := [
	"apt-get",
	"apk",
	"yum",
	"dnf",
	"zypper",
	"pacman",
	"apt",
	"pkg_add",
]

pkg_updater := {
	"apt-get": ["update"],
	"apk": ["update"],
	"yum": ["update"],
	"dnf": ["update"],
	"zypper": ["refresh"],
	"pacman": ["-Syu"],
	"apt": ["update"],
}

pkg_installer := {
	"apt-get": ["install", "source-install", "reinstall"],
	"apk": ["add"],
	"yum": ["install"],
	"dnf": ["install"],
	"zypper": ["install"],
	"pacman": ["-S"],
	"apt": ["install"],
}

exceptions := {"apk": ["--update", "--update-cache", "-U"]}

getRunCommand(resource) = commandRefactor {
	resource.Cmd == "run"
	count(resource.Value) == 1
	command := resource.Value[0]
	commandList := split(command, " ")
	commandRefactor := [x | x := commandList[_]; x != ""]
}

getDetail(commandRefactor, value) = list {
	list := [u | commandRefactor[u] == value]
}

checkException(nextPackageManager, nextCommandRefactor) {
	exp := exceptions[nextPackageManager]
	l := [x | x := getDetail(nextCommandRefactor, exp[_]); count(x) > 0]
	count(l) > 0
}

update_before(update_date, j, install_position) {
	update_date[update_line]
	update_line < j
} else {
	update_position := update_date[update_line]
	update_line == j
	update_position < install_position
}
