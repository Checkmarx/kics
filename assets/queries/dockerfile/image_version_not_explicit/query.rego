package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "from"
	not resource.Value[0] == "scratch"

	versionNotExplicit(resource.Value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("FROM %s:'version'", [resource.Value[0]]),
		"keyActualValue": sprintf("FROM %s'", [resource.Value[0]]),
	}
}

versionNotExplicit(cmd) {
	count(cmd) == 1
	regex.match("^\\$[{}A-z0-9-_+].*", cmd[0]) == false
	not contains(cmd[0], ":")
}

versionNotExplicit(cmd) {
	count(cmd) == 1
	regex.match("^\\$[{}A-z0-9-_+].*", cmd[0]) == true

	resource := input.document[i].command[name][_]
	not resource.Value[0] == "scratch"

	possibilities := {"arg", "env"}
	resource.Cmd == possibilities[j]

	cmdClean := trim_prefix(cmd[0], "$")

	startswith(resource.Value[0], cmdClean)

	not contains(resource.Value[0], ":")
}

versionNotExplicit(cmd) {
	count(cmd) > 1

	not contains(cmd[0], ":")

	resource := input.document[i].command[name][_]
	not resource.Value[0] == "scratch"
	resource.Cmd == "from"

	count(resource.Value) > 1

	resource.Value[1] == "as"

	resource.Value[2] == cmd[0]

	not contains(resource.Value[0], ":")
}
