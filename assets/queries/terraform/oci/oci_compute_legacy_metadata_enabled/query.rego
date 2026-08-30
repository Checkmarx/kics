package Cx

import data.generic.common as common_lib

# RULE 1: Missing The block 'agent_config' por completo.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]

    not instance.agent_config

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s", [instance_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", instance_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'agent_config' block should be defined",
        "keyActualValue": "'agent_config' block is missing",
    }
}

# RULE 2: Exists 'agent_config', but Missing The attribute dentro.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]
    agent_config := instance.agent_config

    object.get(agent_config, "are_legacy_imds_endpoints_disabled", null) == null

    result := {
        "documentId": input.document[i].id,
        # AQUI ESTA EL CAMBIO: Pointing to the block agent_config
        "searchKey": sprintf("resource.oci_core_instance.%s.agent_config", [instance_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", instance_name, "agent_config"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'are_legacy_imds_endpoints_disabled' should be present and set to 'true'",
        "keyActualValue": "'are_legacy_imds_endpoints_disabled' is missing inside 'agent_config'",
    }
}

# RULE 3: The attribute Exists but es 'false'.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]

    instance.agent_config.are_legacy_imds_endpoints_disabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s.agent_config.are_legacy_imds_endpoints_disabled", [instance_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", instance_name, "agent_config", "are_legacy_imds_endpoints_disabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'are_legacy_imds_endpoints_disabled' attribute should be 'true'",
        "keyActualValue": "'are_legacy_imds_endpoints_disabled' attribute is 'false'",
    }
}