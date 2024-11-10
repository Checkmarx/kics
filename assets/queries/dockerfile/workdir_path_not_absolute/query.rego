package Cx

import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.command[name][_]
	resource.Cmd == "workdir"
	not regex.match(`(^\"?/[A-z0-9-_+]*)|(^\"?[A-z0-9-_+]:\\\\.*)|(^\"?\$[{}A-z0-9-_+].*)`, resource.Value[0])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("FROM={{%s}}.WORKDIR={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "'WORKDIR' Command has absolute path",
		"keyActualValue": "'WORKDIR' Command doesn't have absolute path",
	}
}
