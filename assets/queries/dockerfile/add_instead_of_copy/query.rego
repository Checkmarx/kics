package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	stage := input.document[i].command[name]

	resource = stage[s]
	stage[s].Cmd = "add"
	not dockerLib.arrayContains(stage[s].Value, {".tar", ".tar."})

	from_command := get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": get_search_key(from_command, name, resource),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
		"keyActualValue": sprintf("'ADD' %s", [resource.Value[0]]),
	}
}

get_search_key(from_command, name, resource) = searchKey {
	indexof(name, "(") == -1
	searchKey := sprintf("%s={{%s}}.{{%s}}", [from_command.value, name, resource.Original])
} else = searchKey {
	searchKey := sprintf("%s={{%s}}.{{%s}}#%d", [from_command.value, get_name(name), resource.Original, from_command.EndLine-1])
}

get_original_from_command(commands) = from_command {
	commands[i].Cmd == "from"
	from_command :=  {
		"value": substring(commands[i].Original, 0, 4),
		"EndLine" : commands[i].EndLine
	}
}

get_name(raw_image) = name {
    idx := indexof(raw_image, "(")
    idx >= 0
    name := substring(raw_image, 0, idx)
}