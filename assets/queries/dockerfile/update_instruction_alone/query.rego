package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) == 1
	command := resource.Value[0]

	isValidUpdate(command)
	not phpComposerPhar(command)
	not updateFollowedByInstall(command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Instruction 'RUN <package-manager> update' should be followed by 'RUN <package-manager> install' ",
		"keyActualValue": "Instruction 'RUN <package-manager> update' isn't followed by 'RUN <package-manager> install in the same 'RUN' statement",
	}
}

isValidUpdate(command) {
	contains(command, " update ")
}

isValidUpdate(command) {
	contains(command, " --update ")
}

isValidUpdate(command) {
	array_split := split(command, " ")

	len = count(array_split)

	update := {"update", "--update"}

	array_split[len - 1] == update[j]
}

phpComposerPhar(command) {
	php := {x | x := indexof_n(command, "php"); count(x) != 0}
	count(php) > 0
	composer := {x | x := indexof_n(command, "composer"); count(x) != 0}
	count(composer) > 0
	checkFollowedBy(php[_],composer)
	update := {x | x := indexof_n(command, "update"); count(x) != 0}
	count(update) > 0
	checkFollowedBy(composer[_],update)
}

commandList := [
	"install",
	"source-install",
	"reinstall",
	"groupinstall",
	"localinstall",
	"add",
]

updateFollowedByInstall(command) {
	update := {x | x := indexof_n(command, "update"); count(x) != 0}
	count(update) > 0
	install := {x | x := indexof_n(command, commandList[_]); count(x) != 0}
	count(install) > 0
	checkFollowedBy(update[_], install)
}

checkFollowedBy(first, after) {
	first[_] < after[_][_]
}
