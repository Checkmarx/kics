package Cx

import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.command[name][_]
	resource.Cmd == "from"
	not resource.Value[0] == "scratch"

	versionNotExplicit(resource.Value)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("FROM %s:'version'", [resource.Value[0]]),
		"keyActualValue": sprintf("FROM %s'", [resource.Value[0]]),
	}
}

versionNotExplicit(cmd) {
	count(cmd) == 1
	regex.match(`^\$[{}A-z0-9-_+].*`, cmd[0]) == false
	not contains(cmd[0], ":")
}

versionNotExplicit(cmd) {
	count(cmd) == 1
	regex.match(`^\$[{}A-z0-9-_+].*`, cmd[0]) == true
	some doc in input.document
	resource := doc.command[name][_]
	not resource.Value[0] == "scratch"

	possibilities := {"arg", "env"}
	some possibility in possibilities
	resource.Cmd == possibility

	cmdClean := trim_prefix(cmd[0], "$")

	startswith(resource.Value[0], cmdClean)

	not contains(resource.Value[0], ":")
}

versionNotExplicit(cmd) {
	count(cmd) > 1

	not contains(cmd[0], ":")
	count([x | x := input.document[i].command[name][_]; build_name_exists(x, cmd[0])]) == 0
}

build_name_exists(resource, build_name) {
	not resource.Value[0] == "scratch"
	resource.Cmd == "from"

	count(resource.Value) > 1

	lower(resource.Value[1]) == "as"

	resource.Value[2] == build_name
}
