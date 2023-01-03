package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
	containersType := containers[_]

	not common_lib.valid_key(containersType, "security_context")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.name={{%s}}", [resourceType, name, specInfo.path, types[x], containersType.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context should be set", [resourceType, name, specInfo.path, types[x], containersType]),
		"keyActualValue": sprintf("k%s[%s].%s.%s[%d].security_context is undefined", [resourceType, name, specInfo.path, types[x], containersType]),
		"searchLine": common_lib.build_search_line([resourceType, name, specInfo.path],[types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true
    common_lib.valid_key(containers[j], "security_context")
    not common_lib.valid_key(containers[j].security_context, "read_only_root_filesystem")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"searchKey": sprintf("%s[%s].%s.%s.name={{%s}}.security_context", [resourceType, name, specInfo.path, types[x], containers[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.read_only_root_filesystem should be set", [resourceType, name, specInfo.path, types[x], j]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context.read_only_root_filesystem is undefined", [resourceType, name, specInfo.path, types[x], j]),
		"searchLine": common_lib.build_search_line([resourceType, name, specInfo.path],[types[x], "security_context"]),
		"remediation": "read_only_root_filesystem = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_array(containers) == true

	common_lib.valid_key(containers[y], "security_context")
	containers[y].security_context.read_only_root_filesystem == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.name={{%s}}.security_context.read_only_root_filesystem", [resourceType, name, specInfo.path, types[x], containers[y].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s[%d].security_context.read_only_root_filesystem should be set to true", [resourceType, name, specInfo.path, types[x], y]),
		"keyActualValue": sprintf("%s[%s].%s.%s[%d].security_context.read_only_root_filesystem is not set to true", [resourceType, name, specInfo.path, types[x], y]),
		"searchLine": common_lib.build_search_line([resourceType, name, specInfo.path],[types[x], "security_context", "read_only_root_filesystem"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	not common_lib.valid_key(containers, "security_context")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line([resourceType, name, specInfo.path],[types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	not common_lib.valid_key(containers.security_context, "read_only_root_filesystem")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.security_context", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.read_only_root_filesystem should be set", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context.read_only_root_filesystem is undefined", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line([resourceType, name, specInfo.path],[types[x], "security_context"]),
		"remediation": "read_only_root_filesystem = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])
	containers := specInfo.spec[types[x]]

	is_object(containers) == true
	containers.security_context.read_only_root_filesystem == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.%s.security_context.read_only_root_filesystem", [resourceType, name, specInfo.path, types[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.%s.security_context.read_only_root_filesystem should be set to true", [resourceType, name, specInfo.path, types[x]]),
		"keyActualValue": sprintf("%s[%s].%s.%s.security_context.read_only_root_filesystem is not set to true", [resourceType, name, specInfo.path, types[x]]),
		"searchLine": common_lib.build_search_line([resourceType, name, specInfo.path],[types[x], "security_context" ,"read_only_root_filesystem"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
