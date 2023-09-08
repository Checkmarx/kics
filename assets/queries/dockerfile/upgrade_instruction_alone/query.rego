package Cx

CxPolicy[result] {
	command := input.document[i].command[name][_]
	not GetUpdatePackage(command)
    
    nextResource := input.document[i].command[name][_]
	nextCommandRefactor := getRunCommand(nextResource)
    nextPackages := [l | nextCommandRefactor[0] == pkg[l]]
    count(nextPackages) > 0
    nextPackageManager := pkg[nextPackages[0]]
	
    install := [x | x := getDetail(nextCommandRefactor, pkg_installer[nextPackageManager][_]); count(x) > 0]

    count(install) > 0
    
	not checkException(nextPackageManager, nextCommandRefactor)
	
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, nextResource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Instruction 'RUN %s %s' should be combined with 'RUN %s %s' ", [nextPackageManager, pkg_installer[nextPackageManager], nextPackageManager, pkg_updater[nextPackageManager]]),
		"keyActualValue": sprintf("Instruction 'RUN %s %s' isn't combined with 'RUN %s %s in the same 'RUN' statement", [nextPackageManager, pkg_installer[nextPackageManager], nextPackageManager, pkg_updater[nextPackageManager]]),
	}
}

CxPolicy[result] {
	pM = GetUpdatePackage(input.document[i].command[name][j])
    
    nextResource := input.document[i].command[name][k]
	nextCommandRefactor := getRunCommand(nextResource)
    nextPackages := [l | nextCommandRefactor[0] == pkg[l]]
    count(nextPackages) > 0
    nextPackageManager := pkg[nextPackages[0]]
	
    install := [x | x := getDetail(nextCommandRefactor, pkg_installer[nextPackageManager][_]); count(x) > 0]

    count(install) > 0
    
    j >= k
    pM[nextPackageManager][0] > install[0][0]
	
	not checkException(nextPackageManager, nextCommandRefactor)
	
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, nextResource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Instruction 'RUN %s %s' should be combined with 'RUN %s %s' ", [nextPackageManager, pkg_installer[nextPackageManager], nextPackageManager, pkg_updater[nextPackageManager]]),
		"keyActualValue": sprintf("Instruction 'RUN %s %s' isn't combined with 'RUN %s %s in the same 'RUN' statement", [nextPackageManager, pkg_installer[nextPackageManager], nextPackageManager, pkg_updater[nextPackageManager]]),
	}  
}

GetUpdatePackage(resource) = result{
	commandRefactor := getRunCommand(resource)
    packages := [l | commandRefactor[0] == pkg[l]]
    count(packages) > 0
    packageManager := pkg[packages[0]]
    update := [x | x := getDetail(commandRefactor, pkg_updater[packageManager][_]); count(x) > 0]
    count(update) > 0
    result := {
    	packageManager: update[0]
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

exceptions := {
	"apk": ["--update", "--update-cache", "-U"]
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

checkException(nextPackageManager, nextCommandRefactor){
	exp := exceptions[nextPackageManager]
	l := [x | x := getDetail(nextCommandRefactor, exp[_]); count(x) > 0]
	count(l) > 0	
}