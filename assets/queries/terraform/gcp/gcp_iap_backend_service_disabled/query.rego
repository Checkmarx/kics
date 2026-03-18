package Cx

# REGLA 1: El bloque 'iap' está ausente en google_compute_backend_service.
CxPolicy[result] {
    doc := input.document[i]
    bs := doc.resource.google_compute_backend_service[name]

    not bs.iap

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_compute_backend_service.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'google_compute_backend_service.%s' should have an 'iap' block defined", [name]),
        "keyActualValue": sprintf("'google_compute_backend_service.%s' is missing the 'iap' block", [name]),
    }
}

# REGLA 2: El bloque 'iap' existe pero falta 'oauth2_client_id'.
CxPolicy[result] {
    doc := input.document[i]
    bs := doc.resource.google_compute_backend_service[name]

    bs.iap
    not bs.iap.oauth2_client_id

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_compute_backend_service.%s.iap", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'oauth2_client_id' should be defined within the 'iap' block",
        "keyActualValue": "'oauth2_client_id' is missing",
    }
}

# REGLA 3: El bloque 'iap' existe pero falta 'oauth2_client_secret'.
CxPolicy[result] {
    doc := input.document[i]
    bs := doc.resource.google_compute_backend_service[name]

    bs.iap
    not bs.iap.oauth2_client_secret

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_compute_backend_service.%s.iap", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'oauth2_client_secret' should be defined within the 'iap' block",
        "keyActualValue": "'oauth2_client_secret' is missing",
    }
}