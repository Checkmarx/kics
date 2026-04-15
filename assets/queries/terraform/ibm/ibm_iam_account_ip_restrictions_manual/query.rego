package Cx

import data.generic.common as common_lib

# CASE 1: Restricciones de IP no configuradas (Atributo missing).
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_iam_account_settings[name]

    object.get(settings, "allowed_ip_addresses", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_account_settings.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_iam_account_settings", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'allowed_ip_addresses' should be defined with a list of trusted IPs",
        "keyActualValue": "'allowed_ip_addresses' is missing (access allowed from anywhere)",
    }
}

# CASE 2: Restricciones definidas but lista vacía.
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_iam_account_settings[name]
    
    ips := settings.allowed_ip_addresses
    count(ips) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_account_settings.%s.allowed_ip_addresses", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_iam_account_settings", name, "allowed_ip_addresses"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'allowed_ip_addresses' should contain at least one trusted IP/Subnet",
        "keyActualValue": "'allowed_ip_addresses' is empty",
    }
}