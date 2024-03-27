package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	commands := resource.Value[0]

	match := regex.match("(curl|wget)( )*(-(-)?[a-zA-Z-]+ *)*(\")?https://www.openssl.org/source/openssl-3.0.[0-5].tar.gz( )*(\")?", commands)
	match == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OpenSSL version should not be vulnerable",
		"keyActualValue": "OpenSSL version is vulnerable",
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

	targets := {"wget", "curl"}
    contains(resource.Value[j], targets[_])

	match := regex.match("( )*(\")?https://www.openssl.org/source/openssl-3.0.[0-5].tar.gz( )*(\")?", resource.Value[z])
    match == true

	j < z

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "OpenSSL version should not be vulnerable",
		"keyActualValue": "OpenSSL version is vulnerable",
	}
}

