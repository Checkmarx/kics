package Cx

geo_redundant_types := {"GRS", "RAGRS", "GZRS", "RAGZRS"}

# REGLA 1: El tipo de replicación no es Geo-Redundante (ej. es LRS o ZRS).
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[name]

    current_type := sa.account_replication_type
    
    not geo_redundant_types[current_type]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_storage_account.%s.account_replication_type", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'account_replication_type' should be 'GRS', 'RAGRS', 'GZRS', or 'RAGZRS'",
        "keyActualValue": sprintf("'account_replication_type' is set to '%s'", [current_type]),
    }
}