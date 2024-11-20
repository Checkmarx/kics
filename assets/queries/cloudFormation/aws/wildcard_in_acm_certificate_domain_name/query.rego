package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::CertificateManager::Certificate"
	domainName := document.Resources[name].Properties.DomainName
	domainName == "*"

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DomainName", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Certificate.Properties.DomainName' should not contain '*'",
		"keyActualValue": "'Resources.Certificate.Properties.DomainName' contains '*'",
	}
}
