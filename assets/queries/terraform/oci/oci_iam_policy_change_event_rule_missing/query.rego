package Cx

expected_event_types := [
    "com.oraclecloud.identity.createpolicy",
    "com.oraclecloud.identity.updatepolicy",
    "com.oraclecloud.identity.deletepolicy"
]

# REGLA 1: Missing (Global)
# No existe NINGUNA regla en el proyecto que monitoree eventos de Políticas IAM.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    any_policy_rule := [rule |
        rule := input.document[_].resource.oci_events_rule[_]
        event := expected_event_types[_]
        contains(rule.condition, event)
    ]

    count(any_policy_rule) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'oci_events_rule' for IAM Policy changes should exist",
        "keyActualValue": "No 'oci_events_rule' found for IAM Policy changes",
    }
}

# REGLA 2: Incomplete (Local)
# La regla existe y mira eventos de Políticas, pero le falta alguno de los 3 requeridos.
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
        "keyExpectedValue": "The rule condition should include all 3 IAM Policy events (create, update, delete)",
        "keyActualValue": sprintf("The rule is missing %d IAM Policy event(s)", [missing_count]),
    }
}

# REGLA 3: Disabled (Local)
# La regla tiene todos los eventos correctos, pero está deshabilitada.
CxPolicy[result] {
    rule := input.document[i].resource.oci_events_rule[name]

    matches := [event | 
        event := expected_event_types[_]
        contains(rule.condition, event)
    ]
    count(matches) == count(expected_event_types)

    rule.is_enabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_events_rule.%s.is_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_enabled' should be true",
        "keyActualValue": "'is_enabled' is false",
    }
}