package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: The 'encryption_key' block is not defined.
CxPolicy[result] {
    doc := input.document[i]
    lustre := doc.resource.azurerm_managed_lustre_file_system[name]

    not lustre.encryption_key

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_managed_lustre_file_system",
        "resourceName": tf_lib.get_resource_name(lustre, name),
        "searchKey": sprintf("azurerm_managed_lustre_file_system[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_managed_lustre_file_system", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_managed_lustre_file_system.%s' should have an 'encryption_key' block defined", [name]),
        "keyActualValue": sprintf("'azurerm_managed_lustre_file_system.%s' is missing the 'encryption_key' block", [name]),
    }
}
