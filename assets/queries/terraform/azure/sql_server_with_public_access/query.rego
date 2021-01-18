package Cx

CxPolicy [ result ] {
  
  firewall := input.document[i].resource.azurerm_sql_firewall_rule[name]
  firewall.start_ip_address = "0.0.0.0"
  firewall.end_ip_address = "0.0.0.0"
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("azurerm_sql_firewall_rule[%s]", [name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "azurerm_sql_firewall_rule.start_ip_address and end_ip_address different from 0.0.0.0",
                "keyActualValue":   "azurerm_sql_firewall_rule.start_ip_address and end_ip_address equal to 0.0.0.0"
              }
}