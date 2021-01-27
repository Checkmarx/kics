package Cx

CxPolicy[result] {
	from := input.document[i].command[j]
	instruction := from[k]

	instruction.Cmd == "run"

	contains(instruction.Value[0], "apk add")
	not regex.match(`.*apk\s+add\s+(--[a-z]+\s)*(-[a-zA-z]{1}\s)*\s*[^- || --][A-Za-z0-9_-]+=(.+)`, instruction.Value[0])
	searchKey := replace(instruction.Original, "     ", ".")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s", [searchKey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'apk add <package>' should use package pinning form 'apk add <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [instruction.Value[0]]),
	}
}
