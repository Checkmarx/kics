package Cx

# CASO 1: Detección de políticas directas a usuario.
CxPolicy[result] {
    doc := input.document[i]
    policy := doc.resource.ibm_iam_user_policy[name]

    result := {
        "documentId": doc.id,
        "searchKey": sprintf("resource.ibm_iam_user_policy.%s", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "IAM policies should be assigned to Access Groups, not users",
        "keyActualValue": "Direct user policy assignment detected. Manual review required to justify exception.",
    }
}