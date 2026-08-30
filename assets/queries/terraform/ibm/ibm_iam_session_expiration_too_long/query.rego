package Cx

import data.generic.common as common_lib

# RULE 1: Missing The attribute 'session_expiration_in_seconds'.
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_iam_account_settings[name]

    object.get(settings, "session_expiration_in_seconds", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_account_settings.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_iam_account_settings", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'session_expiration_in_seconds' should be defined and set to 3600 (1 hour) or less",
        "keyActualValue": "'session_expiration_in_seconds' is missing (using insecure default)",
    }
}

# RULE 2: La sesión dura más de 1 hora (3600 segundos).
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_iam_account_settings[name]

    expiration := to_number(settings.session_expiration_in_seconds)
    
    expiration > 3600

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_account_settings.%s.session_expiration_in_seconds", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_iam_account_settings", name, "session_expiration_in_seconds"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'session_expiration_in_seconds' should be <= 3600",
        "keyActualValue": sprintf("'session_expiration_in_seconds' is set to '%v'", [expiration]),
    }
}