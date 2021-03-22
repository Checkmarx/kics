package Cx

import data.generic.cloudformation as cloudFormationLib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Properties.ViewerCertificate.CloudFrontDefaultCertificate == false
	not cloudFormationLib.arrayContains(resource.Properties.ViewerCertificate.MinimumProtocolVersion, {"TLSv1.1", "TLSv1.2"})

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion is TLSv1.1 or TLSv1.2", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion isn't TLSv1.1 or TLSv1.2", [name]),
	}
}
