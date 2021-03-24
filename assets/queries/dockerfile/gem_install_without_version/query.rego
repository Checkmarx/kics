package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	gem := regex.find_n("gem (-(-)?[a-zA-Z]+ *)*install", commands, -1)
	gem != null

	packages := dockerLib.getPackages(commands, gem)
	length := count(packages)

	some j
	analyzePackages(j, packages[j], packages, length)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s is 'gem install <gem>:<version>'", [resource.Original]),
		"keyActualValue": sprintf("%s is 'gem install <gem>', you should use 'gem install <gem>:<version>", [resource.Original]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

    dockerLib.arrayContains(resource.Value, {"gem", "install"})

	resource.Value[j] != "install"
	resource.Value[j] != "gem"
	regex.match("^[a-zA-Z]", resource.Value[j]) == true
	not dockerLib.withVersion(resource.Value[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s is 'gem install <gem>:<version>'", [resource.Original]),
		"keyActualValue": sprintf("%s is 'gem install <gem>', you should use 'gem install <gem>:<version>", [resource.Original]),
	}
}

analyzePackages(j, currentPackage, packages, length) {
	j == length - 1
	regex.match("^[a-zA-Z]", currentPackage) == true
	not dockerLib.withVersion(currentPackage)
}

analyzePackages(j, currentPackage, packages, length) {
	j != length - 1
	regex.match("^[a-zA-Z]", currentPackage) == true
	packages[plus(j, 1)] != "-v"
	not dockerLib.withVersion(currentPackage)
}
