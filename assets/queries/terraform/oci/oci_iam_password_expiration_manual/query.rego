package Cx

# CASO 1: Identity Domains - Expiración (password_expires_after) > 365.
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.oci_identity_domains_password_policy[name]

    policy.password_expires_after > 365

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_domains_password_policy.%s.password_expires_after", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'password_expires_after' should be <= 365",
        "keyActualValue": sprintf("'password_expires_after' is %d", [policy.password_expires_after]),
    }
}

# CASO 2: Identity Domains - Atributo faltante.
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.oci_identity_domains_password_policy[name]

    object.get(policy, "password_expires_after", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_domains_password_policy.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'password_expires_after' should be defined (<= 365)",
        "keyActualValue": "'password_expires_after' is missing",
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
        "keyExpectedValue": "Password expiration should be enforced (<= 365 days)",
        "keyActualValue": "Legacy resource does not support password expiration config in Terraform. Manual console check required.",
    }
}