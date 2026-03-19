package Cx

# REGLA 1: El atributo 'versioning' está ausente en el bucket.
# Por defecto, si no se especifica, el versionado está deshabilitado.
CxPolicy[result] {
    bucket := input.document[i].resource.oci_objectstorage_bucket[bucket_name]

    object.get(bucket, "versioning", null) == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_objectstorage_bucket.%s", [bucket_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'versioning' attribute should be present and set to 'Enabled'",
        "keyActualValue": "'versioning' attribute is missing, disabling versioning",
    }
}

# REGLA 2: El atributo 'versioning' existe pero no es 'Enabled'.
# Puede ser 'Disabled' o 'Suspended'.
CxPolicy[result] {
    bucket := input.document[i].resource.oci_objectstorage_bucket[bucket_name]

    object.get(bucket, "versioning", null) != null
    bucket.versioning != "Enabled"

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_objectstorage_bucket.%s.versioning", [bucket_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'versioning' attribute should be 'Enabled'",
        "keyActualValue": sprintf("'versioning' attribute is '%s'", [bucket.versioning]),
    }
}