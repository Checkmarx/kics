package Cx

# REGLA 1: El bloque 'network_rule' no está definido.
# En azurerm_elastic_san_volume_group, la ausencia del bloque permite el acceso público.
CxPolicy[result] {
    doc := input.document[i]
    vg := doc.resource.azurerm_elastic_san_volume_group[name]

    not vg.network_rule

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_elastic_san_volume_group.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_elastic_san_volume_group.%s' should have a 'network_rule' block to restrict public access", [name]),
        "keyActualValue": sprintf("'azurerm_elastic_san_volume_group.%s' is missing the 'network_rule' block", [name]),
    }
}