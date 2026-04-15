package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: IoT Hub has no associated azurerm_iot_security_solution.
# Checked at document level via iothub_ids reference matching.
CxPolicy[result] {
    doc := input.document[i]
    iot_hub := doc.resource.azurerm_iothub[hub_name]

    hub_ref := sprintf("azurerm_iothub.%s.id", [hub_name])

    count([sol |
        sol := doc.resource.azurerm_iot_security_solution[_]
        check_hub_id(sol.iothub_ids[_], hub_ref)
    ]) == 0

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_iothub",
        "resourceName": tf_lib.get_resource_name(iot_hub, hub_name),
        "searchKey": sprintf("azurerm_iothub[%s]", [hub_name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_iothub", hub_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_iothub.%s' should be included in 'iothub_ids' of an 'azurerm_iot_security_solution'", [hub_name]),
        "keyActualValue": sprintf("'azurerm_iothub.%s' is not associated with any 'azurerm_iot_security_solution'", [hub_name]),
    }
}

# RULE 2: IoT Hub has an associated security solution but it is explicitly disabled.
# azurerm_iot_security_solution.enabled defaults to true; setting it to false disables
# Defender for IoT while leaving the resource declared in the configuration.
CxPolicy[result] {
    doc := input.document[i]
    iot_hub := doc.resource.azurerm_iothub[hub_name]

    hub_ref := sprintf("azurerm_iothub.%s.id", [hub_name])

    sol := doc.resource.azurerm_iot_security_solution[sol_name]
    check_hub_id(sol.iothub_ids[_], hub_ref)
    sol.enabled == false

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_iot_security_solution",
        "resourceName": tf_lib.get_resource_name(sol, sol_name),
        "searchKey": sprintf("azurerm_iot_security_solution[%s].enabled", [sol_name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_iot_security_solution", sol_name, "enabled"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'azurerm_iot_security_solution.%s' should have 'enabled' set to true", [sol_name]),
        "keyActualValue": sprintf("'azurerm_iot_security_solution.%s' has 'enabled' explicitly set to false", [sol_name]),
    }
}

check_hub_id(current, target) {
    current == target
}

check_hub_id(current, target) {
    current == sprintf("${%s}", [target])
}
