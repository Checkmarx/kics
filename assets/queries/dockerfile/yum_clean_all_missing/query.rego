package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	dockerLib.check_multi_stage(name, input.document[i].command)

	resource.Cmd == "run"

	command := resource.Value[0]

	output := regex.match("yum (-[a-zA-Z]+ *)*install", command)
	output == true

	not containsCleanAfterYum(command)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should have 'yum clean all' after 'yum install' command", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} doesn't have 'yum clean all' after 'yum install' command", [resource.Original]),
	}
}

containsCleanAfterYum(command) {
	yumInstallCommand := regex.find_n("yum (-[a-zA-Z]+ *)*install", command, -1)

	install := indexof(command, yumInstallCommand[0])
	install != -1

	clean := indexof(command, "yum clean all")
	clean != -1

	install < clean
}
