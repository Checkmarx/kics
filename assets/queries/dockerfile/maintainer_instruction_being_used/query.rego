package Cx

import future.keywords.in

CxPolicy[result] {
	some i, name
	some document in input.document
	resource := document.command[name][_]
	resource.Cmd == "maintainer"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.MAINTAINER={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Maintainer instruction being used in Label 'LABEL maintainer=%s'", [resource.Value[0]]),
		"keyActualValue": sprintf("Maintainer instruction not being used in Label 'MAINTAINER %s'", [resource.Value[0]]),
	}
}
