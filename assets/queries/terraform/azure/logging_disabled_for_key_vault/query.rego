package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_key_vault[resource_name]
    getDataSourceFor(resource) == null
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault[%s]", [resource_name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'data.azurerm_key_vault' is defined for 'azurerm_key_vault[%s]'", [resource_name]),
                "keyActualValue": 	sprintf("'data.azurerm_key_vault' is not defined for 'azurerm_key_vault[%s]'", [resource_name]),
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_key_vault[resource_name]
    data_name := getDataSourceFor(resource)
    data_name != null
    not monitorExistsFor(data_name)
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_key_vault[%s]", [resource_name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting' is defined for 'azurerm_key_vault[%s]'", [resource_name]),
                "keyActualValue": 	sprintf("'azurerm_monitor_diagnostic_setting' is not defined for 'azurerm_key_vault[%s]'", [resource_name]),
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_key_vault[resource_name]
    data_name := getDataSourceFor(resource)
    data_name != null
    resource_id := sprintf("${data.azurerm_key_vault.%s.id}", [data_name])
    monitor := input.document[j].resource.azurerm_monitor_diagnostic_setting[monitor_name]
    monitor.target_resource_id == resource_id
    not ExistsLogAuditEvent(monitor)
    
    result := {
                "documentId": 		input.document[j].id,
                "searchKey": 	    sprintf("azurerm_monitor_diagnostic_setting[%s]", [monitor_name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log' is defined for category 'AuditEvent'", [monitor_name]),
                "keyActualValue": 	sprintf("'azurerm_monitor_diagnostic_setting[%s].log' is not defined for category 'AuditEvent'", [monitor_name]),
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_key_vault[resource_name]
    data_name := getDataSourceFor(resource)
    data_name != null
    resource_id := sprintf("${data.azurerm_key_vault.%s.id}", [data_name])
    monitor := input.document[j].resource.azurerm_monitor_diagnostic_setting[monitor_name]
    monitor.target_resource_id == resource_id
    ExistsLogAuditEvent(monitor)
    LogAuditEventDisabled(monitor.log)
    
    result := {
                "documentId": 		input.document[j].id,
                "searchKey": 	    sprintf("azurerm_monitor_diagnostic_setting[%s].log", [monitor_name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log.enabled' for category 'AuditEvent' is true or undefined", [monitor_name]),
                "keyActualValue": 	sprintf("'azurerm_monitor_diagnostic_setting[%s].log.enabled' for category 'AuditEvent' is false", [monitor_name]),
              }
}

monitorExistsFor(data_name) {
    resource_id := sprintf("${data.azurerm_key_vault.%s.id}", [data_name])
    some m
    	input.document[i].resource.azurerm_monitor_diagnostic_setting[m].target_resource_id == resource_id
}

getDataSourceFor(resource) = result {
	data := input.document[i].data.azurerm_key_vault[data_name]
    data.name == resource.name
    data.resource_group_name == resource.resource_group_name
    result := data_name
} else = null

ExistsLogAuditEvent(monitor) {
	logs := monitor.log
	is_object(logs)
    logs.category == "AuditEvent"
}
ExistsLogAuditEvent(monitor) {
	logs := monitor.log
	is_array(logs)
    some l
    	logs[l].category == "AuditEvent"
}

LogAuditEventDisabled(logs) {
	is_object(logs)
    logs.category == "AuditEvent"
    logs.enabled == false
}
LogAuditEventDisabled(logs) {
	is_array(logs)
    some l
    	logs[l].category == "AuditEvent"
        logs[l].enabled == false
}