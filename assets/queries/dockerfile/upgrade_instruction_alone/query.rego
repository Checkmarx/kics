package play

import future.keywords.if

CxPolicy[result] {
	resource := input.document[i].command[name][j]

	command := getRunCommand(resource)
	packages := [l | command[0] == pkg[l]]
	count(packages) > 0
	packageManager := pkg[packages[0]]
	install_position := getDetail(command, pkg_installer[packageManager][_])
	count(install_position) > 0

	update_data := getUpdateCommand(input.document[i])
    not update_before(update_data, j, install_position)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, command]),
		"issueType": "IncorrectValue",
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

	not getUpdateCommand(input.document[i])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, command]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Instruction 'RUN %s %s' should be combined with 'RUN %s %s' ", [packageManager, pkg_installer[packageManager], packageManager, pkg_updater[packageManager]]),
		"keyActualValue": sprintf("Instruction 'RUN %s %s' isn't combined with 'RUN %s %s in the same 'RUN' statement", [packageManager, pkg_installer[packageManager], packageManager, pkg_updater[packageManager]]),
	}
}

getUpdateCommand(document) = result {
	resource := document.command[_][j]
	command := getRunCommand(resource)
	packages := [l | command[0] == pkg[l]]
	count(packages) > 0
	packageManager := pkg[packages[0]]
	position := getDetail(command, pkg_installer[packageManager][_])
	count(position) > 0
    result = {
    	j: position
    }
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

getRunCommand(resource) = commandRefactor if {
	resource.Cmd == "run"
	count(resource.Value) == 1
	command := resource.Value[0]
	commandList := split(command, " ")
	commandRefactor := [x | x := commandList[_]; x != ""]
}

getDetail(commandRefactor, value) = list if {
	list := [u | commandRefactor[u] == value]
}

checkException(nextPackageManager, nextCommandRefactor) if {
	exp := exceptions[nextPackageManager]
	l := [x | x := getDetail(nextCommandRefactor, exp[_]); count(x) > 0]
	count(l) > 0
}


update_before(update_date, j, install_position) {
	line := update_date[update_line]
	line < j
} else {
	update_date[_] < install_position
}
