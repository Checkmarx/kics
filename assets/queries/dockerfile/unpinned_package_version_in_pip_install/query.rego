package Cx

CxPolicy[result] {
	from := input.document[i].command[j]
	instruction := from[k]

	instruction.Cmd == "run"

	contains(instruction.Value[0], "pip install")
	not contains(instruction.Value[0], " -r ")
	not regex.match(`pip\s+install\s+(--[a-z]+\s+)*(-[a-zA-z]{1}\s+)*\s*[^- || --][A-Za-z0-9_-]+=(.+)`, instruction.Value[0])
	searchKey := replace(instruction.Original, "     ", ".")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s", [searchKey]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'pip install <package>' should use package pinning form 'pip install <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [instruction.Value[0]]),
	}
}
