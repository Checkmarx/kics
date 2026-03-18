package Cx

# REGLA 1: Existe una VNet, pero no existe ningún recurso azurerm_bastion_host en el documento.
CxPolicy[result] {
    doc := input.document[i]
    
    vnet := doc.resource.azurerm_virtual_network[name]

    bastions := [b | b := doc.resource.azurerm_bastion_host[_]]

    count(bastions) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_virtual_network.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("An 'azurerm_bastion_host' resource should be defined to protect Virtual Network '%s'", [name]),
        "keyActualValue": "No 'azurerm_bastion_host' resource was found in the configuration",
    }
}