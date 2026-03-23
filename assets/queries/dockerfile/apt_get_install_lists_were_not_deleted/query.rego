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
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.RUN={{%s}}", [from_command, name, commands]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "After using apt-get install, the apt-get lists should be deleted",
		"keyActualValue": "After using apt-get install, the apt-get lists were not deleted",
	}
}

options := {"&& ", "; "}

hasClean(resourceValue, aptGet) {
	res := replace(resourceValue, "\t", "")
	listCommands := split(res, options[_])
	startswith(trim_space(listCommands[install]), aptGet)
	startswith(trim_space(listCommands[clean]),  "apt-get clean")
	install < clean
} else {
	res := replace(resourceValue, "\t", "")
	listCommands := split(res, options[_])
	startswith(trim_space(listCommands[install]), aptGet)
	startswith(trim_space(listCommands[remove]),  "rm -rf")
	install < remove
}
