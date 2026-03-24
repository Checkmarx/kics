package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "maintainer"

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	maintainer_command := substring(resource.Original, 0, 10)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.%s={{%s}}", [from_command, name, maintainer_command, resource.Value[0]]),
		"issueType": "IncorrectValue", 
		"keyExpectedValue": sprintf("Maintainer instruction being used in Label 'LABEL maintainer=%s'", [resource.Value[0]]),
		"keyActualValue": sprintf("Maintainer instruction not being used in Label 'MAINTAINER %s'", [resource.Value[0]]),
	}
}
