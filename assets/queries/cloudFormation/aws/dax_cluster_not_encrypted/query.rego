package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
    # case of SSEEnabled set to false
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::DAX::Cluster"
    common_lib.valid_key(resource.Properties,"SSESpecification")
    common_lib.valid_key(resource.Properties.SSESpecification,"SSEEnabled")
    cf_lib.isCloudFormationFalse(resource.Properties.SSESpecification.SSEEnabled)
    

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SSESpecification.SSEEnabled", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SSESpecification.SSEEnabled' should be set to true.", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SSESpecification.SSEEnabled' is set to false.", [name]),
	}
}

CxPolicy[result] {
    # case of no SSEEnabled defined
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::DAX::Cluster"
    common_lib.valid_key(resource.Properties,"SSESpecification")
    not common_lib.valid_key(resource.Properties.SSESpecification,"SSEEnabled")
    

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.SSESpecification", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.SSESpecification' should have SSEEnabled declared and set to true.", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.SSESpecification' does not declare SSEEnabled.", [name]),
	}
}

CxPolicy[result] {
    # case of no SSESpecification defined
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::DAX::Cluster"
    not common_lib.valid_key(resource.Properties,"SSESpecification")
    

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties' should have SSESpecification declared.", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties' does not declare SSESpecification.", [name]),
	}
}

