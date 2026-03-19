package Cx

# REGLA 1: No existe ningún recurso 'ibm_resource_instance' para el servicio 'activity-tracker'.
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

# REGLA 2: El atributo 'platform_logs' está ausente en la instancia de Activity Tracker.
CxPolicy[result] {
    tracker := input.document[i].resource.ibm_resource_instance[tracker_name]
    tracker.service == "activity-tracker"

    object.get(tracker, "platform_logs", null) == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_resource_instance.%s", [tracker_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'platform_logs' attribute should be present and set to 'true'",
        "keyActualValue": "'platform_logs' attribute is missing and defaults to 'false'",
    }
}

# REGLA 3: El atributo 'platform_logs' está explícitamente configurado como 'false'.
CxPolicy[result] {
    tracker := input.document[i].resource.ibm_resource_instance[tracker_name]
    tracker.service == "activity-tracker"

    tracker.platform_logs == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_resource_instance.%s.platform_logs", [tracker_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'platform_logs' attribute should be 'true'",
        "keyActualValue": "'platform_logs' attribute is 'false'",
    }
}