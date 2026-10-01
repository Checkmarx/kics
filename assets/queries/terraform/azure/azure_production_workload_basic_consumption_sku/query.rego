package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: Azure Service Plan using Basic (B), Free (F), or Consumption (Y1) SKU.
CxPolicy[result] {
    doc := input.document[i]
    plan := doc.resource.azurerm_service_plan[name]

    invalid_skus := ["B1", "B2", "B3", "F1", "FREE", "Y1"]
    plan.sku_name == invalid_skus[_]

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_service_plan",
        "resourceName": tf_lib.get_resource_name(plan, name),
        "searchKey": sprintf("azurerm_service_plan[%s].sku_name", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_service_plan", name, "sku_name"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'%s.sku_name' should be Standard (S), Premium (P) or Isolated (I) for production", [name]),
        "keyActualValue": sprintf("'%s.sku_name' is set to '%s' (Basic/Free/Consumption)", [name, plan.sku_name]),
    }
}

# RULE 2: Azure API Management using Basic or Consumption SKU.
CxPolicy[result] {
    doc := input.document[i]
    apim := doc.resource.azurerm_api_management[name]

    regex.match("(Basic|Consumption).*", apim.sku_name)

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_api_management",
        "resourceName": tf_lib.get_resource_name(apim, name),
        "searchKey": sprintf("azurerm_api_management[%s].sku_name", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "sku_name"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'%s.sku_name' should be Standard or Premium for production features", [name]),
        "keyActualValue": sprintf("'%s.sku_name' is set to '%s'", [name, apim.sku_name]),
    }
}
