package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

types = {"AWS::Elasticsearch::Domain", "AWS::OpenSearchService::Domain"}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	field := types[type]
	resource.Type == field

	not common_lib.valid_key(resource.Properties, "DomainEndpointOptions")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s%s.Properties.DomainEndpointOptions.EnforceHTTPS should be defined and set to 'true'", [cf_lib.getPath(path), name]),
		"keyActualValue": sprintf("%s%s.Properties.DomainEndpointOptions.EnforceHTTPS is not set", [cf_lib.getPath(path), name]),
		"searchLine": common_lib.build_search_line([path, Resources, name, field, "Properties"],[]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	field := types[type]
	resource.Type == field

	not common_lib.valid_key(resource.Properties.DomainEndpointOptions, "EnforceHTTPS")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DomainEndpointOptions", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s%s.Properties.DomainEndpointOptions.EnforceHTTPS should be defined and set to 'true'", [cf_lib.getPath(path), name]),
		"keyActualValue": sprintf("%s%s.Properties.DomainEndpointOptions.EnforceHTTPS is not set", [cf_lib.getPath(path), name]),
		"searchLine": common_lib.build_search_line([path, Resources, name, field, "Properties", "DomainEndpointOptions"],[]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	field := types[type]
	resource.Type == field

	cf_lib.isCloudFormationFalse(resource.Properties.DomainEndpointOptions.EnforceHTTPS)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.DomainEndpointOptions.EnforceHTTPS", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s%s.Properties.DomainEndpointOptions.EnforceHTTPS should be set to 'true'", [cf_lib.getPath(path), name]),
		"keyActualValue": sprintf("%s%s.Properties.DomainEndpointOptions.EnforceHTTPS is set to 'false'", [cf_lib.getPath(path), name]),
		"searchLine": common_lib.build_search_line([path, Resources, name, field, "Properties", "DomainEndpointOptions","EnforceHTTPS"],[]),
	}
}