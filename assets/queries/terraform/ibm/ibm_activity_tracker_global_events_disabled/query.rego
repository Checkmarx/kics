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

# RULE 2: An activity-tracker instance is in a region that does not support global events.
CxPolicy[result] {
    global_event_regions := {"eu-de", "eu-gb", "us-south", "au-syd"}

    tracker := input.document[i].resource.ibm_resource_instance[tracker_name]
    tracker.service == "activity-tracker"

    not global_event_regions[tracker.location]

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_resource_instance.%s.location", [tracker_name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_resource_instance", tracker_name, "location"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Activity Tracker 'location' should be a global event region (e.g., 'eu-de', 'us-south')",
        "keyActualValue": sprintf("Activity Tracker 'location' is '%s', which is not a global event region", [tracker.location]),
    }
}
