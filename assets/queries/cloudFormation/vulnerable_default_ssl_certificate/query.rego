package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"

	value := resource.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate
	isAttrTrue(value)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.CloudfrontDefaultCertificate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate is 'false' or not defined.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.CloudfrontDefaultCertificate is 'true'.", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	attr := {"MinimumProtocolVersion", "SslSupportMethod"}

	viewerCertificate := resource.Properties.DistributionConfig.ViewerCertificate

	hasCustomConfig(viewerCertificate)
	object.get(viewerCertificate, attr[a], "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.%s is defined", [name, attr[a]]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.%s is not defined", [name, attr[a]]),
	}
}

isAttrTrue(value) {
	value == "true"
} else {
	value == true
}

hasCustomConfig(viewerCertificate) {
	object.get(viewerCertificate, "IamCertificateId", "undefined") != "undefined"
}

hasCustomConfig(viewerCertificate) {
	object.get(viewerCertificate, "AcmCertificateArn", "undefined") != "undefined"
}
