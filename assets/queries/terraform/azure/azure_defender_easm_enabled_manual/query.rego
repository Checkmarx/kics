package Cx

# REGLA 1: Genera un aviso manual por cada Resource Group encontrado.
CxPolicy[result] {
    doc := input.document[i]
    rg := doc.resource.azurerm_resource_group[name]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.azurerm_resource_group.%s", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("Microsoft Defender EASM should be verified manually for resource group '%s'", [name]),
        "keyActualValue": "EASM status cannot be verified statically via Terraform (Manual Verification Required)",
    }
}