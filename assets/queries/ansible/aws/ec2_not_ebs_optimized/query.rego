package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ans_lib.checkState(ec2)

	instanceType := get_instance_type(ec2)
	not common_lib.is_aws_ebs_optimized_by_default(instanceType)
	not common_lib.valid_key(ec2, "ebs_optimized")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "ec2 to have ebs_optimized set to true.",
		"keyActualValue": "ec2 doesn't have ebs_optimized set to true.",
	}
}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	modules := {"amazon.aws.ec2", "ec2"}
	ec2 := task[modules[m]]
	ans_lib.checkState(ec2)

	instanceType := get_instance_type(ec2)
	not common_lib.is_aws_ebs_optimized_by_default(instanceType)
	ec2.ebs_optimized == false

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ebs_optimized", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ec2 to have ebs_optimized set to true.",
		"keyActualValue": "ec2 ebs_optimized is set to false.",
	}
}

# The default InstanceType is t2.micro as defined by thesse docs(https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_instance_module.html#ansible-collections-amazon-aws-ec2-instance-module)
get_instance_type(instanceProperties) = result {
	common_lib.valid_key(instanceProperties, "instance_type")
	result = instanceProperties.instance_type
} else = result {
	result = "t2.micro"
}
