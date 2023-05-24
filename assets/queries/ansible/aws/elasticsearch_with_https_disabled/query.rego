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
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.domain_endpoint_options.enforce_https should be set to 'true'", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.domain_endpoint_options.enforce_https is set to 'false'", [task.name, modules[m]]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m],"domain_endpoint_options","enforce_https"], []),
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.opensearch", "opensearch"}
	elasticsearch := task[modules[m]]
	ans_lib.checkState(elasticsearch)

	not common_lib.valid_key(elasticsearch.domain_endpoint_options, "enforce_https")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.domain_endpoint_options", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.domain_endpoint_options.enforce_https should be defined and set to 'true'", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.domain_endpoint_options.enforce_https is not set", [task.name, modules[m]]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m],"domain_endpoint_options"], []),
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"community.aws.opensearch", "opensearch"}
	elasticsearch := task[modules[m]]
	ans_lib.checkState(elasticsearch)

	not common_lib.valid_key(elasticsearch, "domain_endpoint_options")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.domain_endpoint_options.enforce_https should be defined and set to 'true'", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.domain_endpoint_options.enforce_https is not set", [task.name, modules[m]]),
		"searchLine": common_lib.build_search_line(["playbooks", t, modules[m]], []),
	}
}