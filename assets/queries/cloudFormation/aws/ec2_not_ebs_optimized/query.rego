package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::Instance"

	instanceType := get_instance_type(resource.Properties)
	not common_lib.is_aws_ebs_optimized_by_default(instanceType)
	not common_lib.valid_key(resource.Properties, "EbsOptimized")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EbsOptimized", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties to have EbsOptimized set to true.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties doesn't have EbsOptimized set to true.", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::Instance"

	resource.Properties.EbsOptimized == false
	instanceType := get_instance_type(resource.Properties)
	not common_lib.is_aws_ebs_optimized_by_default(instanceType)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EbsOptimized", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties to have EbsOptimized set to true.", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EbsOptimized is set to false.", [name]),
	}
}

# The default InstanceType is m1.small as defined by thesse docs(https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance.html)
get_instance_type(instanceProperties) = result {
	common_lib.valid_key(instanceProperties, "InstanceType")
	result = instanceProperties.InstanceType
} else = result {
	result = "m1.small"
}
