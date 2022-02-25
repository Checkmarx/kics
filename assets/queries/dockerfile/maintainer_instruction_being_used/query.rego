package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "maintainer"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.MAINTAINER={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue", 
		"keyExpectedValue": sprintf("Maintainer instruction being used in Label 'LABEL maintainer=%s'", [resource.Value[0]]),
		"keyActualValue": sprintf("Maintainer instruction not being used in Label 'MAINTAINER %s'", [resource.Value[0]]),
	}
}
