package Cx

import data.generic.common as common_lib

# RULE 1: No ibm_resource_instance for activity-tracker exists in the configuration.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.ibm

    all_activity_trackers := [tracker |
        tracker := input.document[_].resource.ibm_resource_instance[_]
        tracker.service == "activity-tracker"
    ]

    count(all_activity_trackers) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.ibm",
        "searchLine": common_lib.build_search_line(["provider", "ibm"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'ibm_resource_instance' with service='activity-tracker' should exist",
        "keyActualValue": "No 'ibm_resource_instance' for service 'activity-tracker' was found",
    }
}

# RULE 2: The 'platform_logs' attribute is missing from the Activity Tracker instance.
CxPolicy[result] {
    tracker := input.document[i].resource.ibm_resource_instance[tracker_name]
    tracker.service == "activity-tracker"

    object.get(tracker, "platform_logs", null) == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_resource_instance.%s", [tracker_name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_resource_instance", tracker_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'platform_logs' attribute should be present and set to 'true'",
        "keyActualValue": "'platform_logs' attribute is missing and defaults to 'false'",
    }
}

# RULE 3: The 'platform_logs' attribute is explicitly set to 'false'.
CxPolicy[result] {
    tracker := input.document[i].resource.ibm_resource_instance[tracker_name]
    tracker.service == "activity-tracker"

    tracker.platform_logs == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_resource_instance.%s.platform_logs", [tracker_name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_resource_instance", tracker_name, "platform_logs"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'platform_logs' attribute should be 'true'",
        "keyActualValue": "'platform_logs' attribute is 'false'",
    }
}
