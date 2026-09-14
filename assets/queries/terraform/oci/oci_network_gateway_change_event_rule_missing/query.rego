package Cx

import data.generic.common as common_lib

expected_event_types := [
    "com.oraclecloud.virtualnetwork.createinternetgateway",
    "com.oraclecloud.virtualnetwork.updateinternetgateway",
    "com.oraclecloud.virtualnetwork.deleteinternetgateway",
    "com.oraclecloud.virtualnetwork.createnatgateway",
    "com.oraclecloud.virtualnetwork.updatenatgateway",
    "com.oraclecloud.virtualnetwork.deletenatgateway",
    "com.oraclecloud.virtualnetwork.createservicegateway",
    "com.oraclecloud.virtualnetwork.updateservicegateway",
    "com.oraclecloud.virtualnetwork.deleteservicegateway",
    "com.oraclecloud.virtualnetwork.createdrg",
    "com.oraclecloud.virtualnetwork.updatedrg",
    "com.oraclecloud.virtualnetwork.deletedrg",
    "com.oraclecloud.virtualnetwork.createlocalpeeringgateway",
    "com.oraclecloud.virtualnetwork.updatelocalpeeringgateway",
    "com.oraclecloud.virtualnetwork.deletelocalpeeringgateway"
]

# RULE 1: No rule exists in the project monitoring Network Gateway change events.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    any_rule := [rule |
        rule := input.document[_].resource.oci_events_rule[_]
        event := expected_event_types[_]
        contains(rule.condition, event)
    ]

    count(any_rule) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "searchLine": common_lib.build_search_line(["provider", "oci"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'oci_events_rule' for Network Gateway changes should exist",
        "keyActualValue": "No 'oci_events_rule' found for Network Gateway changes",
    }
}

# RULE 2: A rule exists but is missing some of the required events.
CxPolicy[result] {
    rule := input.document[i].resource.oci_events_rule[name]

    matches := [event |
        event := expected_event_types[_]
        contains(rule.condition, event)
    ]

    count(matches) > 0
    count(matches) < count(expected_event_types)

    missing_count := count(expected_event_types) - count(matches)

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_events_rule.%s.condition", [name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_events_rule", name, "condition"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "The rule condition should include all required Network Gateway events",
        "keyActualValue": sprintf("The rule is missing %d Network Gateway event(s)", [missing_count]),
    }
}

# RULE 3: A relevant rule exists but is disabled.
CxPolicy[result] {
    rule := input.document[i].resource.oci_events_rule[name]

    matches := [event |
        event := expected_event_types[_]
        contains(rule.condition, event)
    ]
    count(matches) > 0

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
