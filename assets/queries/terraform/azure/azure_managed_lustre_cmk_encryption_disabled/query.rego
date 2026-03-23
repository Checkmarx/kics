package Cx

import data.generic.terraform as tf_lib

# REGLA 1: El bloque 'encryption_key' no está definido.
CxPolicy[result] {
    doc := input.document[i]
    lustre := doc.resource.azurerm_managed_lustre_file_system[name]

    not lustre.encryption_key

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_managed_lustre_file_system",
        "resourceName": tf_lib.get_resource_name(lustre, name),
        "searchKey": sprintf("azurerm_managed_lustre_file_system[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_managed_lustre_file_system.%s' should have an 'encryption_key' block defined", [name]),
        "keyActualValue": sprintf("'azurerm_managed_lustre_file_system.%s' is missing the 'encryption_key' block", [name]),
    }
}
