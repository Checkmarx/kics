package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib


CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"ansible.builtin.uri"}
	builtin_uri := task[modules[m]]
	ansLib.checkState(builtin_uri)

	url := builtin_uri.url
	startswith(url, "http://")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.url", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ansible.builtin.uri.url should be accessed via the HTTPS protocol",
		"keyActualValue": "ansible.builtin.uri.url is accessed via the HTTP protocol'",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m], "url"], []),
	}
}
