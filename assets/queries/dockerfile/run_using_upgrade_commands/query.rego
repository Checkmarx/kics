package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

    dockerLib.arrayContains(resource.Value, {"apt-get upgrade", "apt-get dist-upgrade"})

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("RUN instructions does not have '%s' command", [resource.Value[j]]),
		"keyActualValue": sprintf("RUN instructions have '%s' command", [resource.Value[j]]),
	}
}
