package Cx

import data.generic.dockerfile as dockerLib

data_ext := {
	".txt", ".json", ".yaml", ".yml", ".xml", ".html", ".css", ".md", ".csv",
	".conf", ".cfg", ".ini", ".toml", ".properties", ".log", ".svg", ".png",
	".jpg", ".jpeg", ".gif", ".pem", ".crt",
}

is_data_path(path) {
	endswith(lower(path), data_ext[_])
}

has_non_data_path(values) {
	path := values[_]
	not is_data_path(path)
}

CxPolicy[result] {
	resource := input.document[i].command[name]

	contains(resource[j].Flags[f], "--chown")
	has_non_data_path(resource[j].Value)

	from_command := dockerLib.get_original_from_command(resource)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource[j].Original]), from_command.LineHint),
		"category": "Best Practices",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The 'Dockerfile' shouldn´t contain the 'chown' flag",
		"keyActualValue": "The 'Dockerfile' contains the 'chown' flag",
	}
}
