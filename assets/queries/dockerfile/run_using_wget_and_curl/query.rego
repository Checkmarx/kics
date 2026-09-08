package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]

	wget := getWget(resource[_])
	curl := getCurl(resource[_])

	count(curl) > 0
	count(wget) > 0

	from_command := dockerLib.get_original_from_command(resource)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, curl[0]]), from_command.LineHint),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "Exclusively using 'wget' or 'curl'",
		"keyActualValue": "Using both 'wget' and 'curl'",
	}
}

getWget(cmd) = wget {
	cmd.Cmd == "run"
	count(cmd.Value) == 1

	commandsList = dockerLib.getCommands(cmd.Value[0])

	wget := [x | instruction := commandsList[i]; not contains(instruction, "install "); regex.match("^( )*wget", instruction) == true; x := cmd.Original]
}

getWget(cmd) = wget {
	cmd.Cmd == "run"
	count(cmd.Value) > 1

	cmd.Value[0] == "wget"

	wget := [cmd.Original]
}

getCurl(cmd) = curl {
	cmd.Cmd == "run"
	count(cmd.Value) == 1

	commandsList = dockerLib.getCommands(cmd.Value[0])

	curl := [x | instruction := commandsList[i]; not contains(instruction, "install "); regex.match("^( )*curl", instruction) == true; x := cmd.Original]
}

getCurl(cmd) = curl {
	cmd.Cmd == "run"
	count(cmd.Value) > 1

	cmd.Value[0] == "curl"

	curl := [cmd.Original]
}
