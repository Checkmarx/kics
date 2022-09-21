package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	instanceType := get_instance_type(resource, "instance_type")
	not common_lib.is_aws_ebs_optimized_by_default(instanceType)
	resource.ebs_optimized == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[{{%s}}].ebs_optimized", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ebs_optimized' should be set to true",
		"keyActualValue": "'ebs_optimized' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "ebs_optimized"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "ebs_optimized")

	instanceTypeKey := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "instance_type")
	instanceType := get_instance_type(module, instanceTypeKey)
	not common_lib.is_aws_ebs_optimized_by_default(instanceType)
	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].ebs_optimized", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ebs_optimized' should be set to true",
		"keyActualValue": "'ebs_optimized' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "ebs_optimized"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	instanceType := get_instance_type(resource, "instance_type")
	not common_lib.is_aws_ebs_optimized_by_default(instanceType)
	not common_lib.valid_key(resource, "ebs_optimized")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ebs_optimized' should be set to true",
		"keyActualValue": "'ebs_optimized' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
		"remediation": "ebs_optimized = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "ebs_optimized")
	instanceTypeKey := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "instance_type")

	instanceType := get_instance_type(module, instanceTypeKey)
	not common_lib.is_aws_ebs_optimized_by_default(instanceType)
	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ebs_optimized' should be set to true",
		"keyActualValue": "'ebs_optimized' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

# Since terraform does not provide a default value for instance_type, we use the default value defined on cloud formation
get_instance_type(instanceProperties, instanceKey) = result {
	common_lib.valid_key(instanceProperties, instanceKey)
	result = instanceProperties[instanceKey]
}
