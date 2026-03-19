package Cx

# REGLA 1: El tipo de cifrado no es CMK o no está definido.
CxPolicy[result] {
    doc := input.document[i]
    vg := doc.resource.azurerm_elastic_san_volume_group[name]

    object.get(vg, "encryption_type", "undefined") != "EncryptionAtRestWithCustomerManagedKey"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_elastic_san_volume_group.%s", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'encryption_type' should be set to 'EncryptionAtRestWithCustomerManagedKey'",
        "keyActualValue": sprintf("'encryption_type' is set to '%v'", [object.get(vg, "encryption_type", "PlatformKey (Default)")]),
    }
}

# REGLA 2: Si el tipo es CMK, debe existir tanto el bloque 'encryption' como el bloque 'identity'.
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
        "searchKey": sprintf("resource.azurerm_elastic_san_volume_group.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_elastic_san_volume_group.%s' should have both 'encryption' and 'identity' blocks for CMK", [name]),
        "keyActualValue": sprintf("'azurerm_elastic_san_volume_group.%s' is missing the following block(s): %s", [name, concat(", ", missing)]),
    }
}