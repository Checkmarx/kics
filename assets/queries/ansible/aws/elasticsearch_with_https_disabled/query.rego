package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.opensearch", "opensearch"}
	elasticsearch := task[modules[m]]
	ans_lib.checkState(elasticsearch)

	elasticsearch.domain_endpoint_options.enforce_https == false

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.domain_endpoint_options.enforce_https", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'cache_subnet_group' should be set to true",
		"keyActualValue": "'cache_subnet_group' is set to false",
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m],"domain_endpoint_options","enforce_https"], []),
	}
}
