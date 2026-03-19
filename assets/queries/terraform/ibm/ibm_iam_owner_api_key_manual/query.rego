package Cx

# CASO 1: Detección de API Key de Usuario.
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.ibm_iam_api_key[name]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_api_key.%s", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "The API Key should belong to a functional user or Service ID, NEVER the Account Owner",
        "keyActualValue": "IBM IAM User API Key detected. Verify this key is NOT for the Account Owner.",
    }
}