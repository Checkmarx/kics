package Cx

# CASO 1: No existe el bloque 'restrictions'.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.google_apikeys_key[name]

    not key.restrictions

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_apikeys_key.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'google_apikeys_key.%s' should have 'restrictions.api_targets' defined", [name]),
        "keyActualValue": sprintf("'google_apikeys_key.%s' is missing the 'restrictions' block", [name]),
    }
}

# CASO 2: Existe 'restrictions', pero falta 'api_targets'.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.google_apikeys_key[name]

    key.restrictions
    not key.restrictions.api_targets

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_apikeys_key.%s.restrictions", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "restrictions.api_targets should be defined",
        "keyActualValue": "restrictions.api_targets is missing",
    }
}