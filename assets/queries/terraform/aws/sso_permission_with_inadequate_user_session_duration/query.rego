package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssoadmin_permission_set[name]
	session_duration := resource.session_duration 
	
	more_than_one_hour(session_duration)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ssoadmin_permission_set_inline_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssoadmin_permission_set[%s].session_duration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "session_duration should not be higher than 1 hour",
		"keyActualValue": "session_duration is higher than 1 hour",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssoadmin_permission_set_inline_policy", name, "session_duration"], []),
	}
}

more_than_one_hour(session_duration) {
	time := get_hours_value(session_duration) + get_minutes_value(session_duration) + get_seconds_value(session_duration)
    time > 3600
}

get_hours_value(session_duration) := duration {
	hours_value := trim_suffix(regex.find_all_string_submatch_n(`\d{1,2}H`, session_duration, 1)[0][0], "H")
    duration := 3600 * to_number(hours_value)
} else := 0

get_minutes_value(session_duration) := duration {
	minutes_value := trim_suffix(regex.find_all_string_submatch_n(`\d{1,2}M`, session_duration, 1)[0][0], "M")
    duration := 60 * to_number(minutes_value)
} else := 0

get_seconds_value(session_duration) := duration {
	seconds_value := trim_suffix(regex.find_all_string_submatch_n(`\d{1,2}S`, session_duration, 1)[0][0], "S")
    duration := to_number(seconds_value)
} else := 0
