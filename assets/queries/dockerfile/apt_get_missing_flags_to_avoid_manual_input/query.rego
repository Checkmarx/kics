package Cx

import data.generic.dockerfile as dockerLib
import future.keywords

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1

	commands := resource.Value[j]
	command := dockerLib.getCommands(commands)[_]
	isAptGet(command)

	not avoidManualInput(command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should avoid manual input", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} doesn't avoid manual input", [resource.Original]),
	}
}

CxPolicy[result] {
    resource := input.document[i].command[name][_]
    resource.Cmd == "run"

    count(resource.Value) > 1

    dockerLib.arrayContains(resource.Value, {"apt-get", "install"})

    not avoidManualInputInList(resource.Value)
    
    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("{{%s}} should avoid manual input", [resource.Original]),
        "keyActualValue": sprintf("{{%s}} doesn't avoid manual input", [resource.Original]),
    }
}

isAptGet(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*install", command)
}

avoidManualInputInList(command) {
    flags := ["-y", "--yes", "--assume-yes", "-qy", "-q=2", "-qq"]
    flagq := ["-q"]
    flagquiet := ["--quiet"]
    numberquiet := 1
 
    flagfound := contains(command[_], flags[_])
    quiet_count := count([1 | i := numbers.range(0, count(command) - 1); command[i] == flagquiet])
    quietflag := quiet_count >= numberquiet
	
    checkBoolean(flagfound, quietflag)
}
 
checkBoolean(flag1, flag2) {
    flag1
    not flag2
}

avoidManualInput(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*(-([A-Za-z])*y|--yes|-qq|-q=2|--assume-yes|(-q|--quiet)(.*(-q|--quiet)){1}) (-(-)?[a-zA-Z]+ *)*install", command)
}

avoidManualInput(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*install (-(-)?[a-zA-Z]+ *)*(-([A-Za-z])*y|--yes|-qq|-q=2|--assume-yes|(-q|--quiet)(.*(-q|--quiet)){1})", command)
}

avoidManualInput(command) {
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*install ([A-Za-z0-9\\W]+ *)*(-([A-Za-z])*y|--yes|-qq|-q=2|--assume-yes|(-q|--quiet)(.*(-q|--quiet)){1})", command)
}
