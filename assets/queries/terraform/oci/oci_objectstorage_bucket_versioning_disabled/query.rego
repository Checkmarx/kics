package Cx

import data.generic.common as common_lib

# RULE 1: The 'versioning' attribute is missing en el bucket.
# Por defecto, si no se especifica, el versionado is disabled.
CxPolicy[result] {
    bucket := input.document[i].resource.oci_objectstorage_bucket[bucket_name]

    object.get(bucket, "versioning", null) == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_objectstorage_bucket.%s", [bucket_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_objectstorage_bucket", bucket_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'versioning' attribute should be present and set to 'Enabled'",
        "keyActualValue": "'versioning' attribute is missing, disabling versioning",
    }
}

# RULE 2: The attribute 'versioning' Exists but no es 'Enabled'.
# Puede ser 'Disabled' o 'Suspended'.
CxPolicy[result] {
    bucket := input.document[i].resource.oci_objectstorage_bucket[bucket_name]

    object.get(bucket, "versioning", null) != null
    bucket.versioning != "Enabled"

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_objectstorage_bucket.%s.versioning", [bucket_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_objectstorage_bucket", bucket_name, "versioning"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'versioning' attribute should be 'Enabled'",
        "keyActualValue": sprintf("'versioning' attribute is '%s'", [bucket.versioning]),
    }
}