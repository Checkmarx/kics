package Cx

# REGLA 1: Azure Service Plan usando SKU Basic (B), Free (F) o Consumption (Y1).
CxPolicy[result] {
    doc := input.document[i]
    plan := doc.resource.azurerm_service_plan[name]

    invalid_skus := ["B1", "B2", "B3", "F1", "FREE", "Y1"]
    plan.sku_name == invalid_skus[_]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_service_plan.%s.sku_name", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'%s.sku_name' should be Standard (S), Premium (P) or Isolated (I) for production", [name]),
        "keyActualValue": sprintf("'%s.sku_name' is set to '%s' (Basic/Free/Consumption)", [name, plan.sku_name]),
    }
}

# REGLA 2: Azure API Management usando SKU Basic o Consumption.
CxPolicy[result] {
    doc := input.document[i]
    apim := doc.resource.azurerm_api_management[name]

    regex.match("(Basic|Consumption).*", apim.sku_name)

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_api_management.%s.sku_name", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'%s.sku_name' should be Standard or Premium for production features", [name]),
        "keyActualValue": sprintf("'%s.sku_name' is set to '%s'", [name, apim.sku_name]),
    }
}