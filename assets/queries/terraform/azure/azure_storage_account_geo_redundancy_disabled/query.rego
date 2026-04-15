package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

geo_redundant_types := {"GRS", "RAGRS", "GZRS", "RAGZRS"}

# RULE 1: The replication type is not Geo-Redundant (e.g., it is LRS or ZRS).
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    current_type := sa.account_replication_type

    not geo_redundant_types[current_type]

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, name),
        "searchKey": sprintf("azurerm_storage_account[%s].account_replication_type", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'account_replication_type' should be 'GRS', 'RAGRS', 'GZRS', or 'RAGZRS'",
        "keyActualValue": sprintf("'account_replication_type' is set to '%s'", [current_type]),
    }
}
