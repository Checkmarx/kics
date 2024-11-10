package Cx

import data.generic.dockerfile as dockerLib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.command[name][_]
	dockerLib.check_multi_stage(name, doc.command)

	resource.Cmd == "run"

	command := resource.Value[0]

	output := regex.match(`yum (-[a-zA-Z]+ *)*install`, command)
	output == true

	not containsCleanAfterYum(command)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should have 'yum clean all' after 'yum install' command", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} doesn't have 'yum clean all' after 'yum install' command", [resource.Original]),
	}
}

containsCleanAfterYum(command) {
	yumInstallCommand := regex.find_n(`yum (-[a-zA-Z]+ *)*install`, command, -1)

	install := indexof(command, yumInstallCommand[0])
	install != -1

	clean := indexof(command, "yum clean all")
	clean != -1

	install < clean
}
