package Cx

# Observe values after CLI/config parsing, Helm rendering and scan execution.
# Every rendered fixture produces a finding, so a skipped chart fails the test.
CxPolicy[result] {
    document := input.document[i]
    document.kind == "ConfigMap"
    document.metadata.labels["helm-overrides-e2e"] == "true"

    result := {
        "documentId": document.id,
        "resourceType": document.kind,
        "resourceName": document.metadata.name,
        "searchKey": "data",
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Rendered values match the E2E scenario",
        "keyActualValue": json.marshal(document.data)
    }
}
