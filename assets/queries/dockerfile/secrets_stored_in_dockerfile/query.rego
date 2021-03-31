package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "env"
	checkSecret(resource) == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.ENV={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s ' doesn't exist", [resource.Original]),
		"keyActualValue": sprintf("'%s ' exists", [resource.Original]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "label"
	checkSecret(resource) == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.LABEL={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s ' doesn't exist", [resource.Original]),
		"keyActualValue": sprintf("'%s ' exists", [resource.Original]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	hasSecret(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s ' doesn't exist", [resource.Original]),
		"keyActualValue": sprintf("'%s ' exists", [resource.Original]),
	}
}

hasSecret(resource) {
	count(resource.Value) == 1
	contains(resource.Value[0], "--passwordfile")
}

hasSecret(resource) {
	count(resource.Value) > 1
	contains(resource.Value[_], "--passwordfile")
}

checkSecret(cmd) {
	secrets = [
		"passwd",
		"password",
		"pass",
		"admin_password",
		"secret",
		"key",
		"access",
		"api_secret",
		"api_key",
		"apikey",
		"token",
		"tkn",
	]

	value := cmd.Value[j]
	contains(lower(value), secrets[_])

	check(cmd, j)
}

check(resource, j) {
	resource.Cmd == "label"
	j != 0

	resource.Value[minus(j, 1)] != "description"
	resource.Value[minus(j, 1)] != "maintainer"
}

check(resource, j) {
	j == 0
}
