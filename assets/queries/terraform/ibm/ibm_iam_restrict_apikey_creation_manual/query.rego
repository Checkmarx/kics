package Cx

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { not is_array(x) }

# CASO 1: Revisión de Políticas de Usuario (ibm_iam_user_policy).
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.ibm_iam_user_policy[name]

    roles := ensure_array(policy.roles)
    count(roles) > 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_user_policy.%s.roles", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Roles should not grant 'iam.service_id.create' or 'iam.api_key.create' to non-privileged users",
        "keyActualValue": sprintf("User policy grants roles: %v. Manual review required.", [roles]),
    }
}

# CASO 2: Revisión de Políticas de Grupo de Acceso (ibm_iam_access_group_policy).
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.ibm_iam_access_group_policy[name]

    roles := ensure_array(policy.roles)
    count(roles) > 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_access_group_policy.%s.roles", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Roles should not grant 'iam.service_id.create' or 'iam.api_key.create' to non-privileged users",
        "keyActualValue": sprintf("Access Group policy grants roles: %v. Manual review required.", [roles]),
    }
}