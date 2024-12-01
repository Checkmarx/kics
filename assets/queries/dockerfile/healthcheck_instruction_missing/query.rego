package Cx

import data.generic.dockerfile as dockerLib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.command[name]
	dockerLib.check_multi_stage(name, doc.command)

	not healthcheck_exists(resource)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Dockerfile should contain instruction 'HEALTHCHECK'",
		"keyActualValue": "Dockerfile doesn't contain instruction 'HEALTHCHECK'",
	}
}

healthcheck_exists(resource) {
	some cmd in resource
	cmd.Cmd == "healthcheck"
}
