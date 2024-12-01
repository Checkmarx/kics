package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	volume := document.resource.aws_ebs_volume[volName]
	snapshot := document.resource.aws_ebs_snapshot[snapName]

	volName == split(snapshot.volume_id, ".")[1]

	volume.encrypted == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_ebs_volume",
		"resourceName": snapName,
		"searchKey": sprintf("aws_ebs_volume[%s].encrypted", [snapName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_ebs_volume[%s].encrypted' associated with aws_ebs_snapshot[%s] should be true", [volName, snapName]),
		"keyActualValue": sprintf("'aws_ebs_volume[%s].encrypted' associated with aws_ebs_snapshot[%s] is false", [volName, snapName]),
	}
}

CxPolicy[result] {
	some document in input.document
	volume := document.resource.aws_ebs_volume[volName]
	snapshot := document.resource.aws_ebs_snapshot[snapName]

	volName == split(snapshot.volume_id, ".")[1]

	not common_lib.valid_key(volume, "encrypted")

	result := {
		"documentId": document.id,
		"resourceType": "aws_ebs_snapshot",
		"resourceName": snapName,
		"searchKey": sprintf("aws_ebs_snapshot[%s]", [snapName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_ebs_volume[%s].encrypted' associated with aws_ebs_snapshot[%s] should be set", [volName, snapName]),
		"keyActualValue": sprintf("'aws_ebs_volume[%s].encrypted' associated with aws_ebs_snapshot[%s] is undefined", [volName, snapName]),
	}
}
