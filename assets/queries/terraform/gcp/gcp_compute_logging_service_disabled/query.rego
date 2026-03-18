package Cx

# REGLA 1: El bloque 'metadata' no existe.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.google_compute_instance[name]

    not instance.metadata

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_compute_instance.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'metadata' block should be defined and contain 'google-logging-enabled'",
        "keyActualValue": "'metadata' block is missing",
    }
}

# REGLA 2: El bloque 'metadata' existe pero le falta la clave 'google-logging-enabled'.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.google_compute_instance[name]

    instance.metadata
    not instance.metadata["google-logging-enabled"]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_compute_instance.%s.metadata", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'google-logging-enabled' should be defined within metadata",
        "keyActualValue": "'google-logging-enabled' is missing in metadata",
    }
}

# REGLA 3: La clave existe pero su valor es 'false'.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.google_compute_instance[name]

    val := instance.metadata["google-logging-enabled"]
    val == "false"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_compute_instance.%s.metadata.google-logging-enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'google-logging-enabled' should be set to 'true'",
        "keyActualValue": "'google-logging-enabled' is set to 'false'",
    }
}