package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as commonLib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Properties.ViewerCertificate.CloudFrontDefaultCertificate == false
	not commonLib.inArray({"TLSv1.1", "TLSv1.2"}, resource.Properties.ViewerCertificate.MinimumProtocolVersion)

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion is TLSv1.1 or TLSv1.2", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ViewerCertificate.MinimumProtocolVersion isn't TLSv1.1 or TLSv1.2", [name]),
	}
}
