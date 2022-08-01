	package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:ec2:Instance"


	not common_lib.is_aws_ebs_optimized_by_default(resource.properties.instanceType)
	not common_lib.valid_key(resource.properties, "ebsOptimized")


	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'ebsOptimized' should be defined and set to true",
		"keyActualValue": "Attribute 'ebsOptimized' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:ec2:Instance"

	not common_lib.is_aws_ebs_optimized_by_default(resource.properties.instanceType)
	ebsOptimized := resource.properties.ebsOptimized
	ebsOptimized == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.ebsOptimized", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'ebsOptimized' should be set to true",
		"keyActualValue": "Attribute 'ebsOptimized' is set to false",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["ebsOptimized"]),
	}
}
