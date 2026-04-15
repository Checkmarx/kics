package Cx

expected_event_types := [
    "com.oraclecloud.virtualnetwork.createnetworksecuritygroup",
    "com.oraclecloud.virtualnetwork.updatenetworksecuritygroup",
    "com.oraclecloud.virtualnetwork.deletenetworksecuritygroup"
]

# RULE 1: Missing (Global)
# No rule exists in the project monitoring NSGs.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    any_nsg_rule := [rule |
        rule := input.document[_].resource.oci_events_rule[_]
        event := expected_event_types[_]
        contains(rule.condition, event)
    ]

    count(any_nsg_rule) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "searchLine": common_lib.build_search_line(["provider", "oci"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'oci_events_rule' for Network Security Group changes should exist",
        "keyActualValue": "No 'oci_events_rule' found for Network Security Group changes",
    }
}

# RULE 2: Incomplete (Local)
# The rule Exists, but is missing events (ej: tiene create but Missing delete).
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
        "keyExpectedValue": "The rule condition should include all 3 NSG events (create, update, delete)",
        "keyActualValue": sprintf("The rule is missing %d NSG event(s)", [missing_count]),
    }
}

# RULE 3: Disabled (Local)
# The rule es relevante (NSG) but está apagada.
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