package Cx

CxPolicy[result] {
	# Check if there is a command that runs install before update
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) == 1
	command := resource.Value[0]
    commandList := split(command, " ")
    commandRefactor := [x | x := commandList[_]; x != ""]
    packages := [l | commandRefactor[0] == pkg[l]]
    count(packages) > 0
    packageManager := pkg[packages[0]]

	update := [x | x := getDetail(commandRefactor, pkg_updater[packageManager][_]); count(x) > 0]
    count(update) > 0

	install := [x | x := getDetail(commandRefactor, pkg_installer[packageManager][_]); count(x) > 0]
    count(install) > 0

	not checkFollowedBy(update, install)
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Instruction 'RUN %s %s' should be followed by 'RUN %s %s' in the same 'RUN' statement", [packageManager, pkg_installer[packageManager], packageManager, pkg_updater[packageManager]]),
		"keyActualValue": sprintf("Instruction 'RUN %s %s' isn't followed by 'RUN %s %s in the same 'RUN' statement", [packageManager, pkg_installer[packageManager], packageManager, pkg_updater[packageManager]]),
	}
}

CxPolicy[result] {
	#Check if there is Update Command without Install Command
	resource := input.document[i].command[name][n]
	commandRefactor := getRunCommand(resource)
    packages := [l | commandRefactor[0] == pkg[l]]
    count(packages) > 0
    packageManager := pkg[packages[0]]

	update := [x | x := getDetail(commandRefactor, pkg_updater[packageManager][_]); count(x) > 0]
    count(update) > 0

	install := [x | x := getDetail(commandRefactor, pkg_installer[packageManager][_]); count(x) > 0]
    count(install) == 0
	
    #Check if any of the next commands is RUN install Command and there is not Update Command
    nextResources := array.slice(input.document[i].command[name], n+1, count(input.document[i].command[name]))
    nextResource := nextResources[_]
	nextCommandRefactor := getRunCommand(nextResource)
    nextPackages := [l | nextCommandRefactor[0] == pkg[l]]
    count(nextPackages) > 0
    nextPackageManager := pkg[nextPackages[0]]
	nextPackageManager == packageManager
    
	nextInstall := [x | x := getDetail(nextCommandRefactor, pkg_installer[nextPackageManager][_]); count(x) > 0]
    count(nextInstall) > 0

	nextUpdate := [x | x := getDetail(nextCommandRefactor, pkg_updater[nextPackageManager][_]); count(x) > 0]
    count(nextUpdate) == 0
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, nextResource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Instruction 'RUN %s %s' should be combined with 'RUN %s %s' in the same 'RUN' statement", [nextPackageManager, pkg_installer[nextPackageManager], nextPackageManager, pkg_updater[nextPackageManager]]),
		"keyActualValue": sprintf("Instruction 'RUN %s %s' isn't combined with 'RUN %s %s in the same 'RUN' statement", [nextPackageManager, pkg_installer[nextPackageManager], nextPackageManager, pkg_updater[nextPackageManager]]),
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
    "pkg_add"
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


getRunCommand(resource) = commandRefactor {
	resource.Cmd == "run"
	count(resource.Value) == 1
	command := resource.Value[0]
    commandList := split(command, " ")
    commandRefactor := [x | x := commandList[_]; x != ""]
}

getDetail(commandRefactor, value) = list{
	list := [u | commandRefactor[u] == value]
}

checkFollowedBy(first, after) {
	first[_] < after[_]
}
