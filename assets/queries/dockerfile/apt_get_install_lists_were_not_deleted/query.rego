package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	commands := resource.Value[0]

	aptGet := regex.find_n("apt-get (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	aptGet != null

	not hasClean(resource.Value[0], aptGet[0])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	run_command := substring(resource.Original, 0, 3)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.%s={{%s}}", [from_command.Value, name, run_command, commands]), from_command.LineHint),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "After using apt-get install, the apt-get lists should be deleted",
		"keyActualValue": "After using apt-get install, the apt-get lists were not deleted",
	}
}

options := {"&& ", "; "}

hasClean(resourceValue, aptGet) {
	res := replace(resourceValue, "\t", "")
	listCommands := split(res, options[_])
	starts_with_apt(listCommands[install], aptGet)
	startswith(trim_space(listCommands[clean]),  "apt-get clean")
	install < clean
} else {
	res := replace(resourceValue, "\t", "")
	listCommands := split(res, options[_])
	starts_with_apt(listCommands[install], aptGet)
	startswith(trim_space(listCommands[remove]),  "rm -rf")
	install < remove
}

# An env assignment such as DEBIAN_FRONTEND=noninteractive may precede apt-get.
starts_with_apt(command, aptGet) {
	startswith(trim_space(command), aptGet)
} else {
	stripped := regex.replace(trim_space(command), `^([A-Za-z_][A-Za-z0-9_]*=\S+\s+)+`, "")
	stripped != trim_space(command)
	startswith(stripped, aptGet)
}
