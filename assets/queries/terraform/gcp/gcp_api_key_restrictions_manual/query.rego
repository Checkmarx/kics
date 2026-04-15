package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# CASO 1: No hay restricciones definidas.
CxPolicy[result] {
    doc := input.document[i]
    key := doc.resource.google_apikeys_key[name]

    not key.restrictions

    result := {
        "documentId": doc.id,
        "resourceType": "google_apikeys_key",
        "resourceName": tf_lib.get_resource_name(key, name),
        "searchKey": sprintf("google_apikeys_key[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_apikeys_key", name], []),
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
        "resourceType": "google_apikeys_key",
        "resourceName": tf_lib.get_resource_name(key, name),
        "searchKey": sprintf("google_apikeys_key[%s].restrictions", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_apikeys_key", name, "restrictions"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Restrictions should be verified against allowed IPs/Referrers",
        "keyActualValue": "Restrictions are present. Manual verification required.",
    }
}
