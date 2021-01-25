package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Properties.ViewerCertificate.CloudFrontDefaultCertificate == false
	not checkMinPortocolVersion(resource.Properties.ViewerCertificate.MinimumProtocolVersion)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion is TLSv1.1 or TLSv1.2", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion isn't TLSv1.1 or TLSv1.2", [name]),
	}
}

checkMinPortocolVersion(version) {
	version == "TLSv1.1"
}

checkMinPortocolVersion(version) {
	version == "TLSv1.2"
}
