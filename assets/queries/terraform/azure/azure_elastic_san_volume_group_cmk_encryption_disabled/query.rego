package Cx

import data.generic.terraform as tf_lib

# RULE 1: The encryption type is not CMK or is not defined.
CxPolicy[result] {
    doc := input.document[i]
    vg := doc.resource.azurerm_elastic_san_volume_group[name]

    object.get(vg, "encryption_type", "undefined") != "EncryptionAtRestWithCustomerManagedKey"

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_elastic_san_volume_group",
        "resourceName": tf_lib.get_resource_name(vg, name),
        "searchKey": sprintf("azurerm_elastic_san_volume_group[%s]", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'encryption_type' should be set to 'EncryptionAtRestWithCustomerManagedKey'",
        "keyActualValue": sprintf("'encryption_type' is set to '%v'", [object.get(vg, "encryption_type", "PlatformKey (Default)")]),
    }
}

# RULE 2: If the type is CMK, both the 'encryption' block and the 'identity' block must exist.
CxPolicy[result] {
    doc := input.document[i]
    vg := doc.resource.azurerm_elastic_san_volume_group[name]
    vg.encryption_type == "EncryptionAtRestWithCustomerManagedKey"

    required_blocks := {"encryption", "identity"}
    existing_blocks := {b | vg[b]}
    missing := required_blocks - existing_blocks

    count(missing) > 0

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_elastic_san_volume_group",
        "resourceName": tf_lib.get_resource_name(vg, name),
        "searchKey": sprintf("azurerm_elastic_san_volume_group[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_elastic_san_volume_group.%s' should have both 'encryption' and 'identity' blocks for CMK", [name]),
        "keyActualValue": sprintf("'azurerm_elastic_san_volume_group.%s' is missing the following block(s): %s", [name, concat(", ", missing)]),
    }
}
