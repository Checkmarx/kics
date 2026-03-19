package Cx

expected_event := "com.oraclecloud.identitycontrolplane.updateidentityprovider"

# REGLA 1: Missing (Global)
# No existe NINGUNA regla en el proyecto que monitoree el evento de Identity Provider.
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
        "issueType": "MissingAttribute",
        "keyExpectedValue": "An 'oci_events_rule' for Identity Provider changes should exist",
        "keyActualValue": "No 'oci_events_rule' found for Identity Provider changes",
    }
}

# REGLA 2: Disabled (Local)
# La regla existe y monitorea IdP, pero está deshabilitada.
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