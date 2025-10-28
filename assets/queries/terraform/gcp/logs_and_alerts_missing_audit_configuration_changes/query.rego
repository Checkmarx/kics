package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resources := {"google_logging_metric", "google_monitoring_alert_policy"}

CxPolicy[result] {
	doc := input.document[i]
	log_or_alert := doc.resource[resources[m]][name]
	filter_data := get_filter(log_or_alert, resources[m], name)

	not regex.match(filter_data.filter, "\\s*protoPayload\\.methodName[ \\n]*=[ \\n]*\\\"SetIamPolicy\\\"[ \\n]*AND[ \\n]*protoPayload\\.serviceData\\.policyDelta\\.auditConfigDeltas\\[ \\n]*:[ \\n]*\\*\\s*")

	result := {
		"documentId": doc.id,
		"resourceType": resources[m],
		"resourceName": tf_lib.get_resource_name(log_or_alert, name),
		"searchKey": sprintf("%s[%s].%s", [resources[m], name, filter_data.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].%s' should capture all audit configuration changes", [resources[m], name, filter_data.path]),
		"keyActualValue": sprintf("'%s[%s].%s' does not capture all audit configuration changes", [resources[m], name, filter_data.path]),
		"searchLine": common_lib.build_search_line(filter_data.searchArray, [])
	}
}

get_filter(resource, type, name) = filter {
	type == "google_logging_metric"
	filter := {
		"filter" : resource.filter,
		"path" : "filter",
		"searchArray" : ["resource", type, name]
	}
} else = filter{
	filter := {
		"filter" : resource.conditions.condition_matched_log.filter,
		"path" : "conditions.condition_matched_log.filter",
		"searchArray" : ["resource", type, name]
	}
}
