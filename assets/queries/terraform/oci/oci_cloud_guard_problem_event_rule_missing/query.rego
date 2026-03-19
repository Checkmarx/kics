package Cx

CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    expected_event_type := "com.oraclecloud.cloudguard.problem"

    rules_with_correct_event := [rule |
        rule := input.document[_].resource.oci_events_rule[_]
        rule.is_enabled == true
        contains(rule.condition, expected_event_type)
    ]

    count(rules_with_correct_event) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'oci_events_rule' for Cloud Guard problems should exist in the project",
        "keyActualValue": "No 'oci_events_rule' is configured to audit Cloud Guard problems",
    }
}