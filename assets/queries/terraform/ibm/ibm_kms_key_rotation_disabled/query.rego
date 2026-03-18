package Cx

# REGLA 1: El bloque 'rotation_policy' está completamente ausente.
CxPolicy[result] {
    key := input.document[i].resource.ibm_kms_key[key_name]

    not key.rotation_policy

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_kms_key.%s", [key_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'rotation_policy' block should be present and configured",
        "keyActualValue": "'rotation_policy' block is missing",
    }
}

# REGLA 2: El bloque 'rotation_policy' existe, pero le falta 'rotation_interval_month'.
CxPolicy[result] {
    key := input.document[i].resource.ibm_kms_key[key_name]

    policy := key.rotation_policy
    not policy.rotation_interval_month

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_kms_key.%s.rotation_policy", [key_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'rotation_interval_month' should be defined within the rotation policy",
        "keyActualValue": "'rotation_interval_month' is missing",
    }
}

# REGLA 3: 'rotation_interval_month' está explícitamente configurado como 0.
CxPolicy[result] {
    key := input.document[i].resource.ibm_kms_key[key_name]
    
    key.rotation_policy.rotation_interval_month == 0

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.ibm_kms_key.%s.rotation_policy.rotation_interval_month", [key_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'rotation_interval_month' should be a value between 1 and 12",
        "keyActualValue": "'rotation_interval_month' is set to 0, disabling rotation",
    }
}