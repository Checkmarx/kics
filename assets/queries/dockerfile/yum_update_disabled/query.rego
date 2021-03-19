package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]

    dockerLib.arrayContains(resource.Value, {"yum update", "yum update-to", "yum upgrade", "yum upgrade-to"})

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} doesn't enables yum update", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} does enable yum update", [name, resource.Original]),
	}
}
