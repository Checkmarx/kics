package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[id].all
	doc.children.tower.hosts[ip]

    not common_lib.isPrivateIP(ip)

	result := {
		"documentId": input.document[id].id,
		"hostname": "tower",
		"resourceName": "children",
		"searchKey": sprintf("all.children.tower.hosts.%s", [split(ip, ".")[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Ansible Tower IP should be private",
		"keyActualValue": "Ansible Tower IP is public",
	}
}
