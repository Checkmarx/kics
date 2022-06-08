package Cx

import data.generic.common as common_lib
<<<<<<< HEAD
=======
import data.generic.terraform as tf_lib
>>>>>>> v1.5.10

CxPolicy[result] {
	resource := input.document[i].resource
	stack := resource.alicloud_ros_stack_instance[name]
	not common_lib.valid_key(stack, "retain_stacks")

	result := {
		"documentId": input.document[i].id,
<<<<<<< HEAD
=======
		"resourceType": "alicloud_ros_stack_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
>>>>>>> v1.5.10
		"searchKey": sprintf("alicloud_ros_stack_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_ros_stack_instance[%s].retain_stacks should be defined and not null", [name]),
		"keyActualValue": sprintf("alicloud_ros_stack_instance[%s].retain_stacks is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ros_stack_instance", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	stack := resource.alicloud_ros_stack_instance[name]
	stack.retain_stacks == false

	result := {
		"documentId": input.document[i].id,
<<<<<<< HEAD
=======
		"resourceType": "alicloud_ros_stack_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
>>>>>>> v1.5.10
		"searchKey": sprintf("alicloud_ros_stack_instance[%s].retain_stacks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_ros_stack_instance[%s].retain_stacks should be true ", [name]),
		"keyActualValue": sprintf("alicloud_ros_stack_instance[%s].retain_stacks is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ros_stack_instance", name, "retain_stacks"], []),
	}
}
