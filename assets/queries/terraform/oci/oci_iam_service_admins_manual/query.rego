package Cx

# REGLA: Auditoría Manual de Políticas de Gestión (Service Admins).
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.oci_identity_policy[name]

    statement := policy.statements[_]

    regex.match("(?i)\\bmanage\\b", statement)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_policy.%s.statements", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Policy should grant 'manage' on specific families to specific groups (Manual Review)",
        "keyActualValue": sprintf("Policy statement grants management privileges: '%s'. Manual review required.", [statement]),
    }
}