package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudFront::Distribution"
	certificateSource := input.document[i].Resources[name].Properties.DistributionConfig.ViewerCertificate.certificateSource
	expectedvalue := "cloudfront"
	contains(certificateSource, expectedvalue)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.certificateSource", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.certificateSource should be configured as a custom SSL certificate with certificateSource different than 'cloudfron'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.ViewerCertificate.certificateSource is configured as 'cloudfront'", [name]),
	}
}
