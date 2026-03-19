package Cx

ensure_array(x) = x { is_array(x) }
ensure_array(x) = [x] { is_object(x) }

# CASO 1: El bloque launch_options existe, pero la opción está explícitamente en FALSE.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.oci_core_instance[name]

    options := ensure_array(instance.launch_options)
    opt := options[_]

    opt.is_pv_encryption_in_transit_enabled == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_core_instance.%s.launch_options.is_pv_encryption_in_transit_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_pv_encryption_in_transit_enabled' should be set to true",
        "keyActualValue": "'is_pv_encryption_in_transit_enabled' is set to false",
    }
}

# CASO 2: El bloque launch_options existe, pero FALTA el atributo (default es false/inseguro).
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.oci_core_instance[name]

    options := ensure_array(instance.launch_options)
    opt := options[_]

    object.get(opt, "is_pv_encryption_in_transit_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_core_instance.%s.launch_options", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'is_pv_encryption_in_transit_enabled' should be defined and set to true",
        "keyActualValue": "'is_pv_encryption_in_transit_enabled' is missing",
    }
}

# CASO 3: FALTA el bloque launch_options completo.
CxPolicy[result] {
    doc := input.document[i]
    instance := doc.resource.oci_core_instance[name]

    not instance.launch_options

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.oci_core_instance.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'launch_options' block with 'is_pv_encryption_in_transit_enabled = true' should be defined",
        "keyActualValue": "'launch_options' block is missing",
    }
}