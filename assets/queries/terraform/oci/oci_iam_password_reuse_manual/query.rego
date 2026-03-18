package Cx

# CASO 1: Identity Domains - Historial insuficiente (< 24).
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.oci_identity_domains_password_policy[name]

    policy.num_passwords_in_history < 24

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_domains_password_policy.%s.num_passwords_in_history", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'num_passwords_in_history' should be >= 24",
        "keyActualValue": sprintf("Current history size is %d", [policy.num_passwords_in_history]),
    }
}

# CASO 2: Identity Domains - Atributo faltante.
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.oci_identity_domains_password_policy[name]

    object.get(policy, "num_passwords_in_history", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_domains_password_policy.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'num_passwords_in_history' should be defined (>= 24)",
        "keyActualValue": "'num_passwords_in_history' is missing",
    }
}

# CASO 3: IAM Clásico (Legacy) - Manual.
CxPolicy[result] {
    doc := input.document[i]
    _ := doc.resource.oci_identity_authentication_policy[name]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_authentication_policy.%s", [name]),
        "issueType": "MissingAttribute", 
        "keyExpectedValue": "Password reuse prevention should be enabled (History >= 24)",
        "keyActualValue": "Legacy resource does not support password history settings in Terraform. Manual console check required.",
    }
}