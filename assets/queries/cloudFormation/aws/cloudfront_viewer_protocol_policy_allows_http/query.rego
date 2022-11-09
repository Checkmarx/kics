package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Properties.DistributionConfig.DefaultCacheBehavior.ViewerProtocolPolicy == "allow-all"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.DefaultCacheBehavior.ViewerProtocolPolicy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.DefaultCacheBehavior.ViewerProtocolPolicy is 'https-only' or 'redirect-to-https'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.DefaultCacheBehavior.ViewerProtocolPolicy is 'allow-all'", [name]),
	}
}

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Properties.DistributionConfig.CacheBehaviors[_].ViewerProtocolPolicy == "allow-all"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.DistributionConfig.CacheBehaviors.ViewerProtocolPolicy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.CacheBehaviors.ViewerProtocolPolicy is 'https-only' or 'redirect-to-https'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DistributionConfig.CacheBehaviors.ViewerProtocolPolicy is 'allow-all'", [name]),
	}
}
