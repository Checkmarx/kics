package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	contains(resource.Value[0], "pip install")
	not contains(resource.Value[0], " -r ")
	not regex.match(`pip\s+install\s+(--[a-z]+\s+)*(-[a-zA-z]{1}\s+)*\s*[^- || --][A-Za-z0-9_-]+=(.+)`, resource.Value[0])
	searchKey := replace(resource.Original, "     ", ".")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction with 'pip install <package>' should use package pinning form 'pip install <package>=<version>'",
		"keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [resource.Value[0]]),
	}
}
