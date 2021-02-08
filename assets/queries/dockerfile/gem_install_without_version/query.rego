package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	commands := resource.Value[0]

	gem := regex.find_n("gem (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	gem != null

	packages = dockerLib.getPackages(commands, gem)
	regex.match("^[a-zA-Z]", packages[j]) == true

	not dockerLib.withVersion(packages[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, commands]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s is 'gem install <gem>:<version>'", [resource.Original]),
		"keyActualValue": sprintf("%s is 'gem install <gem>', you should use 'gem install <gem>:<version>", [resource.Original]),
	}
}
