package Cx

# REGLA 1: Bloque 'log_config' ausente.
CxPolicy[result] {
    doc := input.document[i]
    bs := doc.resource.google_compute_backend_service[name]

    not bs.log_config

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_compute_backend_service.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "log_config should be defined with enable set to true",
        "keyActualValue": "log_config is missing",
    }
}

# REGLA 2: Bloque 'log_config' existe pero 'enable' es false.
CxPolicy[result] {
    doc := input.document[i]
    bs := doc.resource.google_compute_backend_service[name]

    bs.log_config.enable == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_compute_backend_service.%s.log_config.enable", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "log_config.enable should be set to true",
        "keyActualValue": "log_config.enable is set to false",
    }
}