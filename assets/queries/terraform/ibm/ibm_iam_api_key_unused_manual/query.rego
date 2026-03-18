package Cx

# CASO 1: IBM Cloud IAM API Key (Usuario).
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.ibm_iam_api_key[name]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_api_key.%s", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "An external process should monitor and disable this key if unused for 180 days",
        "keyActualValue": "IBM IAM User API Key created via Terraform. Manual verification of lifecycle policy required.",
    }
}

# CASO 2: IBM Cloud IAM Service API Key (Service ID).
CxPolicy[result] {
    doc := input.document[i]
    resource := doc.resource.ibm_iam_service_api_key[name]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_service_api_key.%s", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "An external process should monitor and disable this key if unused for 180 days",
        "keyActualValue": "IBM IAM Service API Key created via Terraform. Manual verification of lifecycle policy required.",
    }
}