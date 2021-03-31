package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CertificateManager::Certificate"
	domainName := input.document[i].Resources[name].Properties.DomainName
	domainName == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DomainName", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Certificate.Properties.DomainName' should not contain '*'",
		"keyActualValue": "'Resources.Certificate.Properties.DomainName' contains '*'",
	}
}
