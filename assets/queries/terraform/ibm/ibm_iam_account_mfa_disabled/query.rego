package Cx

# REGLA 1: El recurso 'ibm_iam_account_settings' no existe en la configuración.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.provider.ibm

    all_iam_settings := [settings |
        settings := input.document[_].resource.ibm_iam_account_settings[_]
    ]

    count(all_iam_settings) == 0

    result := {
        "documentId": doc.id,
        "searchKey": "provider.ibm",
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Resource 'ibm_iam_account_settings' should exist to enforce MFA",
        "keyActualValue": "Resource 'ibm_iam_account_settings' is missing in this IBM configuration",
    }
}

# REGLA 2: El atributo 'mfa' está ausente dentro del recurso.
CxPolicy[result] {
    settings := input.document[i].resource.ibm_iam_account_settings[settings_name]
    object.get(settings, "mfa", null) == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_iam_account_settings.%s", [settings_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'mfa' attribute should be present and set to 'LEVEL2' or 'LEVEL3'",
        "keyActualValue": "'mfa' attribute is missing",
    }
}

# REGLA 3: El atributo 'mfa' tiene un valor inseguro ('NONE' o 'LEVEL1').
CxPolicy[result] {
    settings := input.document[i].resource.ibm_iam_account_settings[settings_name]
    insecure_mfa_levels := {"NONE", "LEVEL1"}
    insecure_mfa_levels[settings.mfa]

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_iam_account_settings.%s.mfa", [settings_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'mfa' attribute should be 'LEVEL2' or 'LEVEL3'",
        "keyActualValue": sprintf("'mfa' attribute is set to '%s'", [settings.mfa]),
    }
}