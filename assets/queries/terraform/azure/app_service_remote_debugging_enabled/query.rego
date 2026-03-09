package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_app_service[name]
    site := resource.site_config
    site.remote_debugging_enabled == true
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_app_service",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_app_service[%s].site_config.remote_debugging_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_app_service[%s].site_config.remote_debugging_enabled should be false", [name]),
        "keyActualValue": sprintf("azurerm_app_service[%s].site_config.remote_debugging_enabled is true", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_app_service", name, "site_config", "remote_debugging_enabled"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_linux_web_app[name]
    site := resource.site_config
    site.remote_debugging_enabled == true
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_linux_web_app",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_linux_web_app[%s].site_config.remote_debugging_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_linux_web_app[%s].site_config.remote_debugging_enabled should be false", [name]),
        "keyActualValue": sprintf("azurerm_linux_web_app[%s].site_config.remote_debugging_enabled is true", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_linux_web_app", name, "site_config", "remote_debugging_enabled"], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_windows_web_app[name]
    site := resource.site_config
    site.remote_debugging_enabled == true
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_windows_web_app",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_windows_web_app[%s].site_config.remote_debugging_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_windows_web_app[%s].site_config.remote_debugging_enabled should be false", [name]),
        "keyActualValue": sprintf("azurerm_windows_web_app[%s].site_config.remote_debugging_enabled is true", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_windows_web_app", name, "site_config", "remote_debugging_enabled"], []),
    }
}
