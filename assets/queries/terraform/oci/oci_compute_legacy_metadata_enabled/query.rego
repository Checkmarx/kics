package Cx

# REGLA 1: Falta el bloque 'agent_config' por completo.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]

    not instance.agent_config

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s", [instance_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'agent_config' block should be defined",
        "keyActualValue": "'agent_config' block is missing",
    }
}

# REGLA 2: Existe 'agent_config', pero falta el atributo dentro.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]
    agent_config := instance.agent_config

    object.get(agent_config, "are_legacy_imds_endpoints_disabled", null) == null

    result := {
        "documentId": input.document[i].id,
        # AQUI ESTA EL CAMBIO: Apuntamos al bloque agent_config
        "searchKey": sprintf("resource.oci_core_instance.%s.agent_config", [instance_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'are_legacy_imds_endpoints_disabled' should be present and set to 'true'",
        "keyActualValue": "'are_legacy_imds_endpoints_disabled' is missing inside 'agent_config'",
    }
}

# REGLA 3: El atributo existe pero es 'false'.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]

    instance.agent_config.are_legacy_imds_endpoints_disabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s.agent_config.are_legacy_imds_endpoints_disabled", [instance_name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'are_legacy_imds_endpoints_disabled' attribute should be 'true'",
        "keyActualValue": "'are_legacy_imds_endpoints_disabled' attribute is 'false'",
    }
}