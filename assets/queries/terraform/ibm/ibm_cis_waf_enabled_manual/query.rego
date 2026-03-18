package Cx

# CASO 1: El atributo 'waf' existe pero tiene un valor incorrecto (ej. "off").
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_cis_domain_settings[name]

    settings.waf
    settings.waf != "on"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cis_domain_settings.%s.waf", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'waf' attribute should be set to 'on'",
        "keyActualValue": sprintf("'waf' attribute is set to '%s'", [settings.waf]),
    }
}

# CASO 2: El atributo 'waf' NO existe en el recurso (valor por defecto varía por plan, se requiere definición explícita).
CxPolicy[result] {
    doc := input.document[i]
    settings := doc.resource.ibm_cis_domain_settings[name]

    not settings.waf

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_cis_domain_settings.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'waf' attribute should be defined and set to 'on'",
        "keyActualValue": "'waf' attribute is missing",
    }
}