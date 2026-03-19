package Cx

# CASO 1: No hay restricciones definidas.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.google_apikeys_key[name]

    not key.restrictions

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_apikeys_key.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'google_apikeys_key.%s' should have a 'restrictions' block defined", [name]),
        "keyActualValue": sprintf("'google_apikeys_key.%s' is missing the 'restrictions' block", [name]),
    }
}

# CASO 2: Hay restricciones definidas.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.google_apikeys_key[name]

    key.restrictions

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_apikeys_key.%s.restrictions", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Restrictions should be verified against allowed IPs/Referrers",
        "keyActualValue": "Restrictions are present. Manual verification required.",
    }
}