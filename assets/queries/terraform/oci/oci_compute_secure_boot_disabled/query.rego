package Cx

import data.generic.common as common_lib

# RULE 1: The 'platform_config' block is missing entirely.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]

    not instance.platform_config

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s", [instance_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", instance_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'platform_config' block should be defined with 'is_secure_boot_enabled' set to true",
        "keyActualValue": "'platform_config' block is missing",
    }
}

# RULE 2: 'platform_config' exists but 'is_secure_boot_enabled' is missing.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]
    platform_config := instance.platform_config

    object.get(platform_config, "is_secure_boot_enabled", null) == null

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s.platform_config", [instance_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", instance_name, "platform_config"], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'is_secure_boot_enabled' should be present inside 'platform_config' and set to 'true'",
        "keyActualValue": "'is_secure_boot_enabled' is missing inside 'platform_config'",
    }
}

# RULE 3: The attribute exists but is 'false'.
CxPolicy[result] {
    instance := input.document[i].resource.oci_core_instance[instance_name]

    instance.platform_config.is_secure_boot_enabled == false

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("resource.oci_core_instance.%s.platform_config.is_secure_boot_enabled", [instance_name]),
        "searchLine": common_lib.build_search_line(["resource", "oci_core_instance", instance_name, "platform_config", "is_secure_boot_enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'is_secure_boot_enabled' attribute should be 'true'",
        "keyActualValue": "'is_secure_boot_enabled' attribute is 'false'",
    }
}
