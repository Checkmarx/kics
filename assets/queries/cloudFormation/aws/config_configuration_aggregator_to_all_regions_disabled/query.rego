package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Config::ConfigurationAggregator"

    not hasAggregationSources(resource.Properties)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties' should have aggregator sources defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties' does not have aggregator sources defined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Config::ConfigurationAggregator"

    accSources := resource.Properties.AccountAggregationSources
	accs := accSources[j]
    not common_lib.valid_key(accs,"AllAwsRegions")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AccountAggregationSources", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AccountAggregationSources' have all configurations with AllAwsRegions", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AccountAggregationSources' has a configuration without AllAwsRegions", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Config::ConfigurationAggregator"

    accSources := resource.Properties.AccountAggregationSources

	cf_lib.isCloudFormationFalse(accSources[j].AllAwsRegions)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.AccountAggregationSources", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.AccountAggregationSources' have all configurations with AllAwsRegions set to true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.AccountAggregationSources' has a configuration with AllAwsRegions set to false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Config::ConfigurationAggregator"

    orgSource := resource.Properties.OrganizationAggregationSource

    not common_lib.valid_key(orgSource,"AllAwsRegions")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.OrganizationAggregationSource", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.OrganizationAggregationSource.AllAwsRegions' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.OrganizationAggregationSource.AllAwsRegions' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Config::ConfigurationAggregator"

    orgSource := resource.Properties.OrganizationAggregationSource

	cf_lib.isCloudFormationFalse(orgSource.AllAwsRegions)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.OrganizationAggregationSource.AllAwsRegions", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.OrganizationAggregationSource.AllAwsRegions' is true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.OrganizationAggregationSource.AllAwsRegions' is false", [name]),
	}
}

hasAggregationSources(resource) {
    aggregators := ["AccountAggregationSources","OrganizationAggregationSource"]
	common_lib.valid_key(resource, aggregators[_])
}
