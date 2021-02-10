package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	command := resource.Value[0]

	contains(resource.Value[0], "apt-get install")
	commandSplited := split(resource.Value[0], " ")

	"install" == commandSplited[index]

	index + 1 <= count(commandSplited)
	packages := array.slice(commandSplited, index + 1, count(commandSplited))

	some pack
	not startswith(packages[pack], "-")
	noVersion(packages[pack])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "When installing a package, its pin version should be defined",
		"keyActualValue": "The pin version is not defined",
	}
}

noVersion(pack) {
	not contains(pack, "=")
}
