package Cx

CxPolicy [ result ] {
	enc := input.document[i].data.aws_launch_configuration[name][block].encrypted
    enc == false
    not contains(block, "ephemeral")
    contains(block, "block_device")

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_launch_configuration[%s].%s.encrypted", [name, block]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'%s.encrypted' is equal 'true'", [block]),
                "keyActualValue": 	sprintf("'%s.encrypted' is equal 'false'", [block])
              }
}
