package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib


CxPolicy[result] {
    docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "database.aws.crossplane.io")
    resource.kind == "RDSInstance"
    
    forProvider := resource.spec.forProvider
    forProvider.multiAZ == false

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.multiAZ", [resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [resource.metadata.name]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' has MultiAZ value set to false", [resource.metadata.name]),
	}
}


CxPolicy[result] {
    docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "database.aws.crossplane.io")
    resource.kind == "RDSInstance"
    
    forProvider := resource.spec.forProvider
    not common_lib.valid_key(forProvider, "multiAZ")

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [resource.metadata.name]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' MultiAZ property is undefined and by default disabled", [resource.metadata.name]),
	}
}
