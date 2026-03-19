package Cx

# CASO 1: Restricciones de IP no configuradas (Atributo ausente).
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_iam_account_settings[name]

    object.get(settings, "allowed_ip_addresses", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_account_settings.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'allowed_ip_addresses' should be defined with a list of trusted IPs",
        "keyActualValue": "'allowed_ip_addresses' is missing (access allowed from anywhere)",
    }
}

# CASO 2: Restricciones definidas pero lista vacía.
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_iam_account_settings[name]
    
    ips := settings.allowed_ip_addresses
    count(ips) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_account_settings.%s.allowed_ip_addresses", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'allowed_ip_addresses' should contain at least one trusted IP/Subnet",
        "keyActualValue": "'allowed_ip_addresses' is empty",
    }
}