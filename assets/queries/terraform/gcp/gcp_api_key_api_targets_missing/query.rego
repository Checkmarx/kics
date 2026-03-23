package Cx

import data.generic.terraform as tf_lib

# CASE 1: The 'restrictions' block does not exist.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.google_apikeys_key[name]

    not key.restrictions

    result := {
        "documentId": doc.id,
        "resourceType": "google_apikeys_key",
        "resourceName": tf_lib.get_resource_name(key, name),
        "searchKey": sprintf("google_apikeys_key[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'google_apikeys_key.%s' should have 'restrictions.api_targets' defined", [name]),
        "keyActualValue": sprintf("'google_apikeys_key.%s' is missing the 'restrictions' block", [name]),
    }
}

# CASE 2: 'restrictions' exists, but 'api_targets' is missing.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.google_apikeys_key[name]

    key.restrictions
    not key.restrictions.api_targets

    result := {
        "documentId": doc.id,
        "resourceType": "google_apikeys_key",
        "resourceName": tf_lib.get_resource_name(key, name),
        "searchKey": sprintf("google_apikeys_key[%s].restrictions", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "restrictions.api_targets should be defined",
        "keyActualValue": "restrictions.api_targets is missing",
    }
}
