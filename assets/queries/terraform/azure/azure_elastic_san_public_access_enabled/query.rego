package Cx

import data.generic.terraform as tf_lib

# RULE 1: The 'network_rule' block is not defined.
# In azurerm_elastic_san_volume_group, the absence of the block allows public access.
CxPolicy[result] {
    doc := input.document[i]
    vg := doc.resource.azurerm_elastic_san_volume_group[name]

    not vg.network_rule

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_elastic_san_volume_group",
        "resourceName": tf_lib.get_resource_name(vg, name),
        "searchKey": sprintf("azurerm_elastic_san_volume_group[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_elastic_san_volume_group.%s' should have a 'network_rule' block to restrict public access", [name]),
        "keyActualValue": sprintf("'azurerm_elastic_san_volume_group.%s' is missing the 'network_rule' block", [name]),
    }
}
