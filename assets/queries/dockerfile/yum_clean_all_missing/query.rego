package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	command := resource.Value[0]

	output := regex.match("yum (-[a-zA-Z]+ *)*install", command)
	output == true

	not containsCleanAfterYum(command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} does have 'yum clean all' after 'yum install' command", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} doesn't have 'yum clean all' after 'yum install' command", [name, resource.Original]),
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
