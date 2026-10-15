package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: The 'network_rule' block is missing from an azurerm_elastic_san_volume_group.
# network_rule defines a subnet whitelist; its absence means no subnet-level access
# restriction is applied to the volume group.
# Note: public_network_access_enabled is a separate attribute on azurerm_elastic_san
# (the SAN resource itself) and is not present on azurerm_elastic_san_volume_group.
CxPolicy[result] {
    doc := input.document[i]
    vg := doc.resource.azurerm_elastic_san_volume_group[name]

    not vg.network_rule

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_elastic_san_volume_group",
        "resourceName": tf_lib.get_resource_name(vg, name),
        "searchKey": sprintf("azurerm_elastic_san_volume_group[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_elastic_san_volume_group", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_elastic_san_volume_group.%s' should have a 'network_rule' block to restrict access to approved subnets only", [name]),
        "keyActualValue": sprintf("'azurerm_elastic_san_volume_group.%s' has no 'network_rule' block; no subnet-level access restriction is applied", [name]),
    }
}
