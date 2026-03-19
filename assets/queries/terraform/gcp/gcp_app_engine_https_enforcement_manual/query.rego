package Cx

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { not is_array(x) }

# CASO 1: Configuración Insegura en los handlers definidos.
CxPolicy[result] {
    doc := input.document[i]
    app := doc.resource.google_app_engine_standard_app_version[name]

    app.handlers
    
    handlers_list := ensure_array(app.handlers)
    handler := handlers_list[_]

    sec_level := object.get(handler, "security_level", "UNSPECIFIED")
    sec_level != "SECURE_ALWAYS"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_app_engine_standard_app_version.%s.handlers", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'handlers.security_level' should be set to 'SECURE_ALWAYS'",
        "keyActualValue": sprintf("'handlers.security_level' is set to '%s'", [sec_level]),
    }
}

# CASO 2: Configuración Ausente en Terraform (Requiere revisión de app.yaml).
CxPolicy[result] {
    doc := input.document[i]
    app := doc.resource.google_app_engine_standard_app_version[name]

    not app.handlers

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.google_app_engine_standard_app_version.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "If handlers are not defined in Terraform, verify 'app.yaml' contains 'secure: always'",
        "keyActualValue": "Terraform does not define handlers. Manual verification of 'app.yaml' required.",
    }
}