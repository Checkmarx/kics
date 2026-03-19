package Cx

# REGLA 1: Falta el bloque 'shape_config' por completo.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]

    not instance.shape_config

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s", [instance_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'shape_config' block should be defined",
        "keyActualValue": "'shape_config' block is missing",
    }
}

# REGLA 2: Existe 'shape_config', pero falta el atributo dentro.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]
    shape_config := instance.shape_config

    object.get(shape_config, "is_secure_boot_enabled", null) == null

    result := {
        "documentId": input.document[i].id,
        # Apuntamos al bloque shape_config
        "searchKey": sprintf("resource.oci_core_instance.%s.shape_config", [instance_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'is_secure_boot_enabled' should be present inside 'shape_config' and set to 'true'",
        "keyActualValue": "'is_secure_boot_enabled' is missing inside 'shape_config'",
    }
}

# REGLA 3: El atributo existe pero es 'false'.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]

    instance.shape_config.is_secure_boot_enabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s.shape_config.is_secure_boot_enabled", [instance_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_secure_boot_enabled' attribute should be 'true'",
        "keyActualValue": "'is_secure_boot_enabled' attribute is 'false'",
    }
}