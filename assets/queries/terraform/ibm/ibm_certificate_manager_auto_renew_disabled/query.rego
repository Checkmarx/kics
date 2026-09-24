package Cx

import data.generic.common as common_lib

# RULE 1: The 'auto_renew_enabled' attribute is missing en el certificado.
CxPolicy[result] {
    doc := input.document[i]
    certificate := doc.resource.ibm_cm_certificate[cert_name]

    object.get(certificate, "auto_renew_enabled", null) == null

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cm_certificate.%s", [cert_name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_cm_certificate", cert_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'auto_renew_enabled' should be present and set to 'true'",
        "keyActualValue": "'auto_renew_enabled' is missing and defaults to 'false'",
    }
}

# RULE 2: The attribute 'auto_renew_enabled' está explícitamente configurado como 'false'.
CxPolicy[result] {
    doc := input.document[i]
    certificate := doc.resource.ibm_cm_certificate[cert_name]

    certificate.auto_renew_enabled == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cm_certificate.%s.auto_renew_enabled", [cert_name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_cm_certificate", cert_name, "auto_renew_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'auto_renew_enabled' attribute should be 'true'",
        "keyActualValue": "'auto_renew_enabled' attribute is 'false'",
    }
}