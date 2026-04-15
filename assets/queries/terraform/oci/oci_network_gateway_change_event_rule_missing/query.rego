package Cx

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

# RULE 1: Missing (Global)
# No rule exists in the project monitoring Gateways.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    any_gateway_rule := [rule |
        rule := input.document[_].resource.oci_events_rule[_]
        event := expected_event_types[_]
        contains(rule.condition, event)
    ]

    count(any_gateway_rule) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "searchLine": common_lib.build_search_line(["provider", "oci"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'oci_events_rule' for Network Gateway changes should exist",
        "keyActualValue": "No 'oci_events_rule' found for Network Gateway changes",
    }
}

# RULE 2: Incomplete (Local)
# The rule Exists, but is missing events (ej. tiene IGW but Missing NAT).
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
        "issueType": "IncorrectValue",
        "keyExpectedValue": "The rule condition should include all 15 Network Gateway events",
        "keyActualValue": sprintf("The rule is missing %d Network Gateway event(s)", [missing_count]),
    }
}

# RULE 3: Disabled (Local)
# The rule es relevante (gateways) but está apagada.
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
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_enabled' should be true",
        "keyActualValue": "'is_enabled' is false",
    }
}