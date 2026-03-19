package Cx

# REGLA 1: No existe ningún recurso 'ibm_resource_instance' para 'activity-tracker'.
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
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'ibm_resource_instance' with service='activity-tracker' should exist",
        "keyActualValue": "No 'ibm_resource_instance' for service 'activity-tracker' was found",
    }
}

# REGLA 2: Una instancia de 'activity-tracker' está en una región incorrecta para eventos globales.
CxPolicy[result] {
    global_event_regions := {"eu-de", "eu-gb", "us-south", "au-syd"}

    tracker := input.document[i].resource.ibm_resource_instance[tracker_name]
    tracker.service == "activity-tracker"

    not global_event_regions[tracker.location]

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_resource_instance.%s.location", [tracker_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Activity Tracker 'location' should be a global event region (e.g., 'eu-de', 'us-south')",
        "keyActualValue": sprintf("Activity Tracker 'location' is '%s', which is not a global event region", [tracker.location]),
    }
}