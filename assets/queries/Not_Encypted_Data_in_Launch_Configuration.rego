package Cx

SupportedResources = "$.resource.aws_launch_configuration"

CxPolicy [ result ] {
	enc := input.document[i].data.aws_launch_configuration[name][block].encrypted
    enc == false
    not contains(block, "ephemeral")
    contains(block, "block_device")

    result := {
                "foundKye": 		block,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_launch_configuration", name]), block, "encrypted"],
                "issueType":		"IncorrectValue",
                "keyName":			"encrypted",
                "keyExpectedValue": true,
                "keyActualValue": 	false,
                #{metadata}
              }
}
