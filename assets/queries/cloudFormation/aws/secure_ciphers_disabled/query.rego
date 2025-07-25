package Cx

import data.generic.common as commonLib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	cf_lib.isCloudFormationFalse(resource.Properties.ViewerCertificate.CloudFrontDefaultCertificate)
	not commonLib.inArray({"TLSv1.1", "TLSv1.2"}, resource.Properties.ViewerCertificate.MinimumProtocolVersion)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion is TLSv1.1 or TLSv1.2", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion isn't TLSv1.1 or TLSv1.2", [name]),
	}
}
