package Cx

import data.generic.common as common_lib

expected_event := "com.oraclecloud.identitycontrolplane.updateidentityprovider"

# RULE 1: No rule exists in the project monitoring Identity Provider changes.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    any_idp_rule := [rule |
        rule := input.document[_].resource.oci_events_rule[_]
        contains(rule.condition, expected_event)
    ]

    count(any_idp_rule) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "searchLine": common_lib.build_search_line(["provider", "oci"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'oci_events_rule' for Identity Provider changes should exist",
        "keyActualValue": "No 'oci_events_rule' found for Identity Provider changes",
    }
}

# RULE 2: A rule monitors IdP events but is disabled.
CxPolicy[result] {
    rule := input.document[i].resource.oci_events_rule[name]

    contains(rule.condition, expected_event)

    rule.is_enabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_events_rule.%s.is_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_events_rule", name, "is_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_enabled' should be true",
        "keyActualValue": "'is_enabled' is false",
    }
}
