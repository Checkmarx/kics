package Cx

import data.generic.common as common_lib

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { is_object(x) }

# CASE 1: The block 'password_policy' Exists, but el valor es menor a 14.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.oci_identity_authentication_policy[name]

    resource.password_policy
    policies := ensure_array(resource.password_policy)
    policy := policies[_]

    policy.minimum_password_length
    
    to_number(policy.minimum_password_length) < 14

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_authentication_policy.%s.password_policy.minimum_password_length", [name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_identity_authentication_policy", name, "password_policy", "minimum_password_length"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'minimum_password_length' should be 14 or greater",
        "keyActualValue": sprintf("'minimum_password_length' is %d", [to_number(policy.minimum_password_length)]),
    }
}

# CASE 2: The block 'password_policy' Exists, but Missing The attribute 'minimum_password_length'.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.oci_identity_authentication_policy[name]

    resource.password_policy
    policies := ensure_array(resource.password_policy)
    policy := policies[_]

    object.get(policy, "minimum_password_length", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_authentication_policy.%s.password_policy", [name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_identity_authentication_policy", name, "password_policy"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'minimum_password_length' should be explicitly defined (>= 14)",
        "keyActualValue": "'minimum_password_length' is missing (using default)",
    }
}

# CASE 3: The block 'password_policy' Does not exist en absoluto.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.oci_identity_authentication_policy[name]

    not resource.password_policy

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_identity_authentication_policy.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_identity_authentication_policy", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'password_policy' block should be defined with 'minimum_password_length' >= 14",
        "keyActualValue": "'password_policy' block is missing",
    }
}