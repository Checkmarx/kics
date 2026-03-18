package Cx

# REGLA 1: IoT Hub sin solución de seguridad (azurerm_iot_security_solution) asociada.
CxPolicy[result] {
    doc := input.document[i]
    iot_hub := doc.resource.azurerm_iothub[hub_name]

    hub_ref := sprintf("azurerm_iothub.%s.id", [hub_name])

    solutions := [sol |
        sol := doc.resource.azurerm_iot_security_solution[_]
        current_hub_id := sol.iothub_ids[_]
        check_hub_id(current_hub_id, hub_ref)
    ]

    count(solutions) == 0

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_iothub.%s", [hub_name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_iothub.%s' should be included in 'iothub_ids' of an 'azurerm_iot_security_solution'", [hub_name]),
        "keyActualValue": sprintf("'azurerm_iothub.%s' is not associated with any 'azurerm_iot_security_solution'", [hub_name]),
    }
}

check_hub_id(current, target) {
    current == target
}

check_hub_id(current, target) {
    current == sprintf("${%s}", [target])
}