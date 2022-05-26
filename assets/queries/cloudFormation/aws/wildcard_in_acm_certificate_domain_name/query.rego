package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CertificateManager::Certificate"
	domainName := input.document[i].Resources[name].Properties.DomainName
	domainName == "*"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DomainName", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Certificate.Properties.DomainName' should not contain '*'",
		"keyActualValue": "'Resources.Certificate.Properties.DomainName' contains '*'",
	}
}
