package Cx

import data.generic.common as common_lib

# RULE 1: The 'object_events_enabled' attribute is missing (MissingAttribute).
# Default in OCI Terraform is false, así que su ausencia es un riesgo.
CxPolicy[result] {
    bucket := input.document[i].resource.oci_objectstorage_bucket[bucket_name]

    object.get(bucket, "object_events_enabled", null) == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_objectstorage_bucket.%s", [bucket_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_objectstorage_bucket", bucket_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'object_events_enabled' should be present and set to 'true'",
        "keyActualValue": "'object_events_enabled' is missing and defaults to 'false'",
    }
}

# RULE 2: The attribute 'object_events_enabled' está explícitamente en 'false' (IncorrectValue).
CxPolicy[result] {
    bucket := input.document[i].resource.oci_objectstorage_bucket[bucket_name]

    bucket.object_events_enabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_objectstorage_bucket.%s.object_events_enabled", [bucket_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_objectstorage_bucket", bucket_name, "object_events_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'object_events_enabled' attribute should be 'true'",
        "keyActualValue": "'object_events_enabled' attribute is 'false'",
    }
}