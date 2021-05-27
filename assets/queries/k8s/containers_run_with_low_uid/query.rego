package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)
	securityContext := value.securityContext

	to_number(securityContext.runAsUser) < 10000

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.securityContext.runAsUser=%d", [common_lib.concat_path(path), securityContext.runAsUser]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.securityContext.runAsUser should not be a low UID", [common_lib.concat_path(path)]),
		"keyActualValue": sprintf("%s.securityContext.runAsUser is a low UID", [common_lib.concat_path(path)]),
	}
}

CxPolicy[result] {
	doc := input.document[i]

	[path, value] = walk(doc)
	securityContext := value.securityContext

	object.get(securityContext, "runAsUser", "undefined") == "undefined"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.securityContext", [common_lib.concat_path(path)]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.securityContext.runAsUser should be defined", [common_lib.concat_path(path)]),
		"keyActualValue": sprintf("%s.securityContext.runAsUser is undefined", [common_lib.concat_path(path)]),
	}
}
