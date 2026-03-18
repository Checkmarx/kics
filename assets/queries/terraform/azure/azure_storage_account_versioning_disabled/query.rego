package Cx

# CASO 1: Falta el bloque 'blob_properties' completo.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    not sa.blob_properties

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should have 'blob_properties' defined", [name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' is missing 'blob_properties'", [name]),
    }
}

# CASO 2: Existe 'blob_properties' pero falta el atributo 'versioning_enabled'.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.blob_properties
    
    object.get(sa.blob_properties, "versioning_enabled", "undefined") == "undefined"

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s.blob_properties", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "blob_properties.versioning_enabled should be defined and set to true",
        "keyActualValue": "blob_properties.versioning_enabled is missing",
    }
}

# CASO 3: 'versioning_enabled' existe pero está explícitamente a false.
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    sa.blob_properties.versioning_enabled == false

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s.blob_properties.versioning_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "blob_properties.versioning_enabled should be set to true",
        "keyActualValue": "blob_properties.versioning_enabled is set to false",
    }
}