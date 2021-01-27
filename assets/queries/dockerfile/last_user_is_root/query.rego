package Cx

CxPolicy[result] {
	resource := input.document[i].command[name]
	userCmd := [x | resource[j].Cmd == "user"; x := resource[j]]
	userCmd[minus(count(userCmd), 1)].Value[0] == "root"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, userCmd[minus(count(userCmd), 1)].Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Last User isn't root",
		"keyActualValue": "Last User is root",
	}
}
