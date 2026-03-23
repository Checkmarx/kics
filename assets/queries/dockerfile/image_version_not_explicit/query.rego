package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "from"
	not resource.Value[0] == "scratch"

	versionNotExplicit(resource.Value,resource.EndLine)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}", [from_command, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("FROM %s:'version'", [resource.Value[0]]),
		"keyActualValue": sprintf("FROM %s'", [resource.Value[0]]),
	}
}

versionNotExplicit(cmd,line) {
	count(cmd) == 1
	regex.match("^\\$[{}A-z0-9-_+].*", cmd[0]) == false
	not contains(cmd[0], ":")
    count([x | x := input.document[i].command[name][_]; x.EndLine < line; build_name_exists(x, cmd[0])]) == 0
}

versionNotExplicit(cmd,_) {
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

versionNotExplicit(cmd,line) {
	count(cmd) > 1

	not contains(cmd[0], ":")
    count([x | x := input.document[i].command[name][_]; input.document[i].command[name][_].EndLine < line; build_name_exists(x, cmd[0])]) == 0
}

build_name_exists(resource, build_name){
	not resource.Value[0] == "scratch"
	resource.Cmd == "from"

	count(resource.Value) > 1

	lower(resource.Value[1]) == "as"

	resource.Value[2] == build_name
}