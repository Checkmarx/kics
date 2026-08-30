package Cx

import data.generic.common as common_lib

# CASE 1: The attribute 'waf' Exists but tiene un valor incorrecto (ej. "off").
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_cis_domain_settings[name]

    settings.waf
    settings.waf != "on"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cis_domain_settings.%s.waf", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_cis_domain_settings", name, "waf"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'waf' attribute should be set to 'on'",
        "keyActualValue": sprintf("'waf' attribute is set to '%s'", [settings.waf]),
    }
}

# CASE 2: The attribute 'waf' Does not exist en el resource (valor por defecto varía por plan, se requiere definición explícita).
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_cis_domain_settings[name]

    not settings.waf

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cis_domain_settings.%s", [name]),
        "searchLine": common_lib.build_search_line(["resource", "ibm_cis_domain_settings", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'waf' attribute should be defined and set to 'on'",
        "keyActualValue": "'waf' attribute is missing",
    }
}