package Cx

SupportedResources = "$.resource.azurerm_container_registry"

CxPolicy [ result ] {
    resource := input.document[i].resource.azurerm_container_registry[name]

	resource.admin_enabled == true

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_container_registry[%s].admin_enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "false",
                "keyActualValue": 	"true"
              })
}