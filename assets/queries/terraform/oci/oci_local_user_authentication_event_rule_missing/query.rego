package Cx

expected_event := "com.oraclecloud.identity.localuser.authenticate"

# RULE 1: Missing (Global)
# No rule exists in the project monitoring el evento de autenticación local.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.oci

    any_auth_rule := [rule |
        rule := input.document[_].resource.oci_events_rule[_]
        contains(rule.condition, expected_event)
    ]

    count(any_auth_rule) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.oci",
        "searchLine": common_lib.build_search_line(["provider", "oci"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'oci_events_rule' for local user authentication events should exist",
        "keyActualValue": "No 'oci_events_rule' found for local user authentication",
    }
}

# RULE 2: Disabled (Local)
# The rule Exists y monitorea autenticación, but is disabled.
CxPolicy[result] {
    rule := input.document[i].resource.oci_events_rule[name]

    contains(rule.condition, expected_event)

    rule.is_enabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_events_rule.%s.is_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_enabled' should be true",
        "keyActualValue": "'is_enabled' is false",
    }
}