package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudformation_stack[name]

	not common_lib.valid_key(resource, "template_body")
    not common_lib.valid_key(resource, "template_url")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudformation_stack",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudformation_stack[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'template_body' or Attribute 'template_url' should be set",
		"keyActualValue": "Both Attribute 'template_body' and Attribute 'template_url' are undefined",
	}
}
