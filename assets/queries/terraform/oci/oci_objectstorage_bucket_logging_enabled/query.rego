package Cx

# REGLA 1: El atributo 'object_events_enabled' está ausente (MissingAttribute).
# Por defecto en OCI Terraform es false, así que su ausencia es un riesgo.
CxPolicy[result] {
    bucket := input.document[i].resource.oci_objectstorage_bucket[bucket_name]

    object.get(bucket, "object_events_enabled", null) == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_objectstorage_bucket.%s", [bucket_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'object_events_enabled' should be present and set to 'true'",
        "keyActualValue": "'object_events_enabled' is missing and defaults to 'false'",
    }
}

# REGLA 2: El atributo 'object_events_enabled' está explícitamente en 'false' (IncorrectValue).
CxPolicy[result] {
    bucket := input.document[i].resource.oci_objectstorage_bucket[bucket_name]

    bucket.object_events_enabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_objectstorage_bucket.%s.object_events_enabled", [bucket_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'object_events_enabled' attribute should be 'true'",
        "keyActualValue": "'object_events_enabled' attribute is 'false'",
    }
}