package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	run_command_value := resource.Value[_]
	values := split(run_command_value, " ")
	trim_space(values[index]) == "cd"
    path := trim_space(values[index+1])
    not is_full_path(path)
    

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	run_command := substring(resource.Original, 0, 3)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.%s={{%s}}", [from_command.Value, name, run_command, resource.Value[0]]), from_command.EndLine-1),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Using WORKDIR to change directory",
		"keyActualValue": sprintf("RUN %s'", [resource.Value[0]]),
	}
}

is_full_path(path){
	regex.match("^[a-zA-Z]:[\\\/]", path)	
}else {
	startswith( path,"/")
    not contains(path, "/.")
}
