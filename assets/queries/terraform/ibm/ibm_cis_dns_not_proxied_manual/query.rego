package Cx

import data.generic.common as common_lib

# CASO 1: El atributo 'proxied' está explícitamente en false.
CxPolicy[result] {
    doc := input.document[i]
    record := doc.resource.ibm_cis_dns_record[name]

    record.proxied == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cis_dns_record.%s.proxied", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_cis_dns_record", name, "proxied"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'proxied' should be set to 'true' to enable DDoS protection",
        "keyActualValue": "'proxied' is set to 'false'",
    }
}

# CASO 2: El atributo 'proxied' falta (por defecto es false).
CxPolicy[result] {
    doc := input.document[i]
    record := doc.resource.ibm_cis_dns_record[name]

    object.get(record, "proxied", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cis_dns_record.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_cis_dns_record", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'proxied' should be defined and set to 'true' to enable DDoS protection",
        "keyActualValue": "'proxied' is missing (DNS resolution only, no DDoS protection)",
    }
}