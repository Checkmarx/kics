package Cx

storage_families := {
    "object-family",
    "volume-family",
    "file-family",
    "autonomous-database-family"
}

CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.oci_identity_policy[name]
    
    statement := policy.statements[_]
    statement_lower := lower(statement)

    regex.match("(?i)\\bmanage\\b", statement)

    family := storage_families[_]
    contains(statement_lower, family)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_policy.%s.statements", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("Statement granting 'manage' on '%s' should ideally exclude DELETE permissions via 'where request.permission != DELETE'", [family]),
        "keyActualValue": sprintf("Statement grants full 'manage' access (including DELETE) on '%s': '%s'", [family, statement]),
    }
}